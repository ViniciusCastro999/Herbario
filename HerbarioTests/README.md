# HerbarioTests

Testes unitários para o aplicativo Herbario.

## Estrutura de Testes

### PlantIdentificationResponseTests
Testa a decodificação e manipulação do modelo de resposta da API PlantNet.

**Testes inclusos:**
- `testDecodingValidResponse()` - Verifica decodificação de resposta válida
- `testDecodingEmptyResults()` - Verifica resposta sem resultados
- `testHighestScoreResult()` - Verifica ordenação por score

### HistoryViewModelTests
Testa a lógica de gerenciamento do histórico de identificações.

**Testes inclusos:**
- `testInitialState()` - Estado inicial vazio
- `testAddingIdentification()` - Adição de itens ao histórico
- `testHistoryItemOrdering()` - Ordenação cronológica

### PlantOrganTests
Testa o modelo de órgãos da planta (folha, flor, fruto, etc).

**Testes inclusos:**
- `testAllOrganCases()` - Verifica todos os casos
- `testOrganDisplayNames()` - Verifica nomes de exibição
- `testOrganCodable()` - Verifica serialização

### ThemeTests
Testa a configuração de temas e cores da UI.

**Testes inclusos:**
- `testPrimaryButtonStyleApplied()` - Estilo de botão primário
- `testHerbarioColorsExist()` - Cores disponíveis
- `testColorUsageInUI()` - Uso em contexto de UI

### NetworkErrorTests
Testa o tratamento de erros de rede.

**Testes inclusos:**
- `testNetworkErrorCases()` - Todos os tipos de erro
- `testNetworkErrorDescription()` - Descrições de erro
- `testNetworkErrorHandling()` - Tratamento adequado
- `testDecodingErrorCreation()` - Criação de erros de decodificação

## Executar Testes

### No Xcode
```bash
Cmd + U  # Atalho de teclado
```

Ou via menu: Product → Test

### Via linha de comando
```bash
xcodebuild -project Herbario.xcodeproj -scheme HerbarioTests test
```

### No GitHub Actions
Os testes rodam automaticamente em cada push/PR na branch `main`.

## Cobertura de Testes

- ✅ Models (PlantIdentificationResponse, PlantOrgan)
- ✅ ViewModels (HistoryViewModel)
- ✅ Services (NetworkError)
- ✅ UI (Theme, Colors)

## Futuras Melhorias

- [ ] Testes para PlantNetAPIService (mock API calls)
- [ ] Testes para Views usando ViewInspector
- [ ] Testes de integração
- [ ] Testes de performance
- [ ] Aumentar cobertura de testes para 80%+

## Troubleshooting

Se os testes não forem encontrados:
1. Abra o projeto no Xcode
2. File → New → Target
3. Selecione "Unit Testing Bundle"
4. Nome: `HerbarioTests`
5. Target to test: `Herbario`

Os arquivos de teste já estão prontos na pasta `HerbarioTests/`.
