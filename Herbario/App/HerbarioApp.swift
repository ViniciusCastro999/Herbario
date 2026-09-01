//
//  HerbarioApp.swift
//  Herbario
//
//  Ponto de entrada do app. Monta o container do SwiftData e injeta
//  as dependências (Services / Repositories) que as ViewModels usam.
//

import SwiftUI
import SwiftData

@main
struct HerbarioApp: App {

    let modelContainer: ModelContainer

    /// Injeção de dependência simples e explícita (sem DI framework).
    /// Cada ViewModel recebe os protocolos de que precisa, nunca a
    /// implementação concreta — isso é o que permite testar/trocar
    /// a fonte de dados sem tocar na camada de View.
    private let identificationService: PlantIdentificationServicing
    private let historyRepository: HistoryRepository

    init() {
        do {
            modelContainer = try ModelContainer(for: IdentificationHistoryItem.self)
        } catch {
            fatalError("Não foi possível criar o ModelContainer do SwiftData: \(error)")
        }

        identificationService = PlantNetAPIService()
        historyRepository = SwiftDataHistoryRepository(modelContext: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(
                identifyViewModel: IdentifyViewModel(
                    identificationService: identificationService,
                    historyRepository: historyRepository
                ),
                historyViewModel: HistoryViewModel(historyRepository: historyRepository)
            )
            .tint(Color.herbGreen)
            .preferredColorScheme(.dark)
        }
        .modelContainer(modelContainer)
    }
}
