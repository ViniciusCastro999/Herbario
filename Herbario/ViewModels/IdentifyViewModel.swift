//
//  IdentifyViewModel.swift
//  Herbario
//
//  Fluxo simplificado: usuário escolhe o órgão, tira/envia UMA foto,
//  a identificação roda automaticamente e os resultados são
//  navegados via push (NavigationStack), nunca em sheet.
//

import UIKit
import SwiftUI

@MainActor
final class IdentifyViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case failure(String)
    }

    @Published var selectedOrgan: PlantOrgan = .leaf
    @Published var capturedImage: UIImage?
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var results: [SpeciesResult] = []
    @Published var navigateToResults = false
    @Published var showSavedToast = false

    private let identificationService: PlantIdentificationServicing
    private let historyRepository: HistoryRepository
    private var lastResponse: PlantIdentificationResponse?

    init(identificationService: PlantIdentificationServicing, historyRepository: HistoryRepository) {
        self.identificationService = identificationService
        self.historyRepository = historyRepository
    }

    // MARK: - Intents

    func selectOrgan(_ organ: PlantOrgan) {
        selectedOrgan = organ
    }

    /// Chamado assim que uma foto é capturada/escolhida. Dispara a
    /// identificação automaticamente — não existe um botão separado
    /// de "Identificar" na tela inicial.
    func setImage(_ image: UIImage) {
        capturedImage = image
        Task { await identify() }
    }

    func retryIdentify() {
        Task { await identify() }
    }

    private func identify() async {
        guard let capturedImage else { return }
        state = .loading

        let input = PlantImageInput(organ: selectedOrgan, image: capturedImage)

        do {
            let response = try await identificationService.identify(images: [input])
            lastResponse = response
            results = response.results.sorted { $0.score > $1.score }
            state = .idle
            navigateToResults = true
        } catch {
            state = .failure(error.localizedDescription)
        }
    }

    /// Usuário escolheu, na tela de resultados, qual espécie é a correta.
    /// Isso salva no histórico e volta para a tela inicial.
    func select(_ result: SpeciesResult) {
        guard
            let capturedImage,
            let thumbnailData = capturedImage.jpegData(compressionQuality: 0.7)
        else { return }

        let rawData = try? JSONEncoder().encode(lastResponse)

        let item = IdentificationHistoryItem(
            scientificName: result.species.scientificNameWithoutAuthor,
            commonName: result.primaryCommonName,
            family: result.species.family?.scientificNameWithoutAuthor,
            scorePercent: Int((result.score * 100).rounded()),
            imageData: thumbnailData,
            rawResponseData: rawData
        )

        do {
            try historyRepository.save(item)
        } catch {
            state = .failure("Não foi possível salvar no histórico: \(error.localizedDescription)")
            return
        }

        reset()
        showSavedToast = true
    }

    func reset() {
        capturedImage = nil
        results = []
        lastResponse = nil
        state = .idle
        navigateToResults = false
    }

    func dismissError() {
        state = .idle
    }
}
