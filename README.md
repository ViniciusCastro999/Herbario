# 🌿 Herbário

App iOS nativo (Swift + SwiftUI) para identificação de plantas por foto, usando a API do [PlantNet](https://my.plantnet.org/doc/getting-started/introduction).

Tire uma foto na hora ou envie da galeria, escolha o órgão da planta (folha, flor, fruto, casca...) e receba as espécies mais prováveis com nome científico, nome popular, família e grau de confiança. Identificações podem ser salvas em um histórico local.

## ✨ Funcionalidades

- 🏠 Tela inicial minimalista com **visual de vidro (glassmorfismo)** sobre um fundo em gradiente escuro — sem branco em nenhuma tela
- 🌱 Escolha o órgão da planta (grade de ícones) e um **único botão** "Adicionar foto", que abre as opções Câmera/Galeria
- 🔍 Identificação automática assim que a foto é escolhida (sem botão extra)
- 🖼️ Resultados mostram a **foto de referência da própria API do PlantNet** para cada espécie candidata
- 👉 Navegação sempre por **push** (`NavigationStack`) — nenhuma tela de resultado/detalhe abre como sheet
- 🕘 Ao tocar na espécie correta, ela é salva automaticamente no histórico local (SwiftData) e a tela volta sozinha para o início
- 🎨 Tab bar e cards em blur translúcido, tema escuro forçado para consistência visual
- ⚠️ Tratamento de erros de rede, limite de requisições e chave ausente, com opção de tentar de novo

## 🏗️ Arquitetura

Projeto em **MVVM**, com uma camada extra de **Services/Repository** para manter a lógica de negócio testável e independente do SwiftUI:

```
Herbario/
├── App/            → Entry point (HerbarioApp) + injeção de dependências
├── Models/          → Structs/Models (Codable da API + @Model do SwiftData)
├── Services/
│   ├── Network/      → PlantIdentificationServicing (protocolo) + PlantNetAPIService
│   ├── Persistence/  → HistoryRepository (protocolo) + SwiftDataHistoryRepository
│   └── Config/       → Leitura segura da API key
├── ViewModels/       → IdentifyViewModel, HistoryViewModel (ObservableObject)
├── Views/
│   ├── Identify/     → Tela de identificação + componentes específicos
│   ├── History/      → Lista e detalhe do histórico
│   └── Components/   → Botões, badges, empty states reutilizáveis
└── Utilities/        → Extensões (cores, etc.)
```

**Por que essa separação?**
- As `Views` só conhecem a `ViewModel` (via `@Published`/`@ObservedObject`), nunca `URLSession` ou `SwiftData` diretamente.
- As `ViewModels` dependem de **protocolos** (`PlantIdentificationServicing`, `HistoryRepository`), não de implementações concretas — isso permite trocar a fonte de dados ou criar mocks para testes/Previews sem tocar em UI.
- `PlantNetAPIService` isola toda a integração HTTP (multipart/form-data) num único lugar.
- `SwiftDataHistoryRepository` isola a persistência; trocar para Core Data ou uma API remota no futuro não afeta a ViewModel.

## 🔑 Configurando a API key (importante!)

Este projeto **não** tem nenhuma API key no código-fonte versionado. A chave é injetada via `xcconfig` → `Info.plist` → lida em runtime por `APIConfig`.

1. Copie o arquivo de exemplo:
   ```bash
   cp Secrets.xcconfig.example Secrets.xcconfig
   ```
2. Abra `Secrets.xcconfig` e defina sua chave (crie a sua em [my.plantnet.org](https://my.plantnet.org)):
   ```
   PLANTNET_API_KEY = sua_chave_aqui
   ```
3. `Secrets.xcconfig` já está no `.gitignore` — ele nunca será commitado.

> ⚠️ Se você usou este projeto pronto com uma chave de exemplo, **gere uma nova chave e revogue a antiga** antes de publicar o repositório no GitHub, já que qualquer chave que já tenha existido em texto puro deve ser considerada exposta.

## 🚀 Como rodar

Este repositório usa o [XcodeGen](https://github.com/yonaskolb/XcodeGen) para gerar o `.xcodeproj` a partir do `project.yml` — assim o projeto do Xcode não precisa ser versionado (evita conflitos de merge no `.pbxproj`).

```bash
brew install xcodegen
cp Secrets.xcconfig.example Secrets.xcconfig   # e edite com sua chave
xcodegen generate
open Herbario.xcodeproj
```

Requisitos: Xcode 15+, iOS 17+ (usa SwiftData).

## 🧪 Testando com um mock

Como o serviço é injetado via protocolo, dá pra criar um `PlantIdentificationServicing` fake em testes/Previews sem chamar a API real:

```swift
struct FakeIdentificationService: PlantIdentificationServicing {
    func identify(images: [PlantImageInput]) async throws -> PlantIdentificationResponse {
        // retorne um PlantIdentificationResponse mockado
    }
}
```

## 📄 Créditos

Identificação de espécies powered by [Pl@ntNet](https://plantnet.org).

## 📝 Licença

MIT — veja [LICENSE](LICENSE).
