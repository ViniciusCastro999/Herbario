import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var capturedImage: UIImage?
    @State private var currentResult: PlantIdentification?
    @State private var history: [HistoryEntry] = []

    @State private var isIdentifying = false
    @State private var errorMessage: String?

    @State private var showSourceMenu = false
    @State private var showCamera = false
    @State private var photosPickerPresented = false
    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                masthead

                VStack(alignment: .leading, spacing: 16) {
                    CaptureCard(image: capturedImage) {
                        showSourceMenu = true
                    }

                    if capturedImage != nil {
                        actionButtons
                    }

                    if isIdentifying {
                        HStack(spacing: 10) {
                            ProgressView()
                                .tint(Color.herbForest)
                            Text("Examinando as folhas e a forma da planta…")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.herbInkSoft)
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "6B2E17"))
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "F6E7DE"))
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                }

                if let capturedImage, let currentResult {
                    ResultCardView(image: capturedImage, result: currentResult)
                }

                HistoryStripView(entries: history) { entry in
                    capturedImage = entry.image
                    currentResult = entry.result
                    errorMessage = nil
                }

                footerNote
            }
            .padding(.horizontal, 22)
            .padding(.top, 24)
            .padding(.bottom, 48)
        }
        .background(Color.herbPaper.ignoresSafeArea())
        .confirmationDialog("Adicionar foto", isPresented: $showSourceMenu, titleVisibility: .visible) {
            Button("Tirar foto") { showCamera = true }
            Button("Escolher da galeria") { presentPhotoPicker() }
            Button("Cancelar", role: .cancel) {}
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $capturedImage)
                .ignoresSafeArea()
                .onDisappear(perform: resetForNewPhoto)
        }
        .photosPicker(isPresented: $photosPickerPresented, selection: $photosPickerItem, matching: .images)
        .onChange(of: photosPickerItem) { newItem in
            Task { await loadPickedPhoto(newItem) }
        }
    }

    // MARK: - Sections

    private var masthead: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle().fill(Color.herbForest).frame(width: 40, height: 40)
                Image(systemName: "leaf.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.herbPaper)
            }
            Text("Herbário")
                .font(.herbDisplay(32))
                .foregroundStyle(Color.herbForestDeep)
            Text("Fotografe uma folha, uma flor ou um galho — e descubra o nome da planta.")
                .font(.system(size: 15))
                .foregroundStyle(Color.herbInkSoft)
                .lineSpacing(3)
        }
        .padding(.bottom, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.herbHairline).frame(height: 1)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button("Trocar foto") {
                capturedImage = nil
                resetResults()
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Color.herbInkSoft)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.herbHairline, lineWidth: 1))

            Button {
                Task { await runIdentification() }
            } label: {
                Text("Identificar planta")
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .foregroundStyle(Color.herbPaper)
            .background(isIdentifying ? Color.herbMoss : Color.herbForest)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .disabled(isIdentifying)
        }
    }

    private var footerNote: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().fill(Color.herbHairline).frame(height: 1)
                .padding(.bottom, 16)
            Text("A identificação é feita por IA e pode errar, especialmente em fotos desfocadas ou com pouca luz. Trate o resultado como referência — antes de comer, aplicar na pele ou tomar decisões sobre toxicidade, confirme com um especialista ou fonte confiável.")
                .font(.system(size: 12))
                .foregroundStyle(Color.herbInkSoft)
                .lineSpacing(4)
        }
    }

    // MARK: - Actions

    private func presentPhotoPicker() {
        photosPickerPresented = true
    }

    private func loadPickedPhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            capturedImage = uiImage
            resetResults()
        }
        photosPickerItem = nil
    }

    /// Called when the camera sheet dismisses. Any photo just captured is
    /// already in `capturedImage` via the binding — this only clears the
    /// previous identification so a fresh photo doesn't show a stale result.
    private func resetForNewPhoto() {
        resetResults()
    }

    private func resetResults() {
        currentResult = nil
        errorMessage = nil
    }

    private func runIdentification() async {
        guard let capturedImage else { return }
        isIdentifying = true
        errorMessage = nil
        defer { isIdentifying = false }

        do {
            let result = try await ClaudeAPIService.identify(image: capturedImage)
            currentResult = result
            if result.encontrada {
                history.insert(HistoryEntry(image: capturedImage, result: result, date: .now), at: 0)
                if history.count > 12 { history.removeLast() }
            }
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Não foi possível identificar a planta agora."
        }
    }
}

#Preview {
    ContentView()
}
