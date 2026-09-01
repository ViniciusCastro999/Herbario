//
//  HerbarioTests.swift
//  HerbarioTests
//
//  Created by Vinicius Cardoso de Castro on 01/09/26.
//

import Testing

// MARK: - Herbario Test Suite
//
// Estrutura dos testes:
//
// Models/
//   - IdentificationHistoryItemTests: Testa inicialização e decodificação
//   - PlantOrganTests: Testa enums, display names e codificação
//   - PlantIdentificationResponseTests: Testa JSON parsing
//   - PlantImageInputTests: Testa construção de inputs
//
// ViewModels/
//   - HistoryViewModelTests: Testa carregamento, exclusão de itens
//   - IdentifyViewModelTests: Testa identificação, salvamento, reset
//
// Network/
//   - NetworkErrorTests: Testa mensagens de erro
//
// Persistence/
//   - PersistenceTests: Testa persistência de dados
//
// TestHelpers.swift
//   - MockHistoryRepository: Mock da camada de persistência
//   - MockPlantIdentificationService: Mock do serviço de API
//   - UIImage.testImage(): Helper para criar imagens de teste

