# Herbário — app iOS nativo

App SwiftUI nativo para identificar plantas por foto usando a API da Anthropic.

## Requisitos

- Xcode 15 ou mais recente
- iOS 16.4+ como target (usa `PhotosPicker`, disponível desde o iOS 16)
- Uma chave de API da Anthropic (console.anthropic.com)
- Um dispositivo físico para testar a câmera (o Simulador não tem câmera — use "Escolher da galeria" nele)

## 1. Criar o projeto no Xcode

1. Abra o Xcode → **File → New → Project**
2. Escolha **iOS → App**
3. Nome do produto: `Herbario` · Interface: **SwiftUI** · Linguagem: **Swift**
4. Depois de criado, **apague** os arquivos `ContentView.swift` e `HerbarioApp.swift` gerados automaticamente
5. Arraste a pasta `Herbario/` deste projeto (Models, Services, Views, Theme, e os arquivos na raiz) para dentro do seu projeto no Xcode, marcando "Copy items if needed" e o target do app

Estrutura de arquivos incluída:

```
Herbario/
  HerbarioApp.swift          — ponto de entrada do app
  ContentView.swift          — tela principal
  Theme/Theme.swift          — cores e tipografia
  Models/PlantIdentification.swift
  Services/Config.swift      — leitura da chave de API
  Services/ClaudeAPIService.swift — chamada à API e parsing do JSON
  Views/CaptureCard.swift    — moldura tracejada de captura
  Views/CameraPicker.swift   — wrapper da câmera nativa
  Views/ResultCardView.swift — cartão de resultado (estilo ficha de herbário)
  Views/HistoryStripView.swift — tiras de identificações recentes
  Info-Additions.plist       — chaves de permissão a adicionar
```

## 2. Permissões (câmera e galeria)

No Xcode, selecione o target do app → aba **Info** → adicione:

| Chave | Valor sugerido |
|---|---|
| Privacy - Camera Usage Description | O Herbário usa a câmera para fotografar plantas e identificá-las. |
| Privacy - Photo Library Usage Description | O Herbário acessa suas fotos para identificar plantas já fotografadas. |

(Veja `Info-Additions.plist` para o XML equivalente, caso seu projeto use um arquivo Info.plist separado.)

## 3. Configurar a chave de API (sem deixá-la no código)

`Config.swift` lê a chave de `Bundle.main.object(forInfoDictionaryKey: "ANTHROPIC_API_KEY")` — ou seja, ela vem do Info.plist, que por sua vez deve vir de uma **build setting**, não de uma string fixa no código.

1. Crie um arquivo `Secrets.xcconfig` na raiz do projeto (fora do controle de versão — adicione ao `.gitignore`):
   ```
   ANTHROPIC_API_KEY = sk-ant-sua-chave-aqui
   ```
2. No Xcode: selecione o **projeto** (não o target) → aba **Info** → em "Configurations", associe `Secrets.xcconfig` às configurações Debug e Release
3. No target → aba **Info** → adicione a chave `ANTHROPIC_API_KEY` com o valor `$(ANTHROPIC_API_KEY)`
4. Rode o app — `Config.hasValidAPIKey` deve retornar `true`

## 4. Rodar

Selecione um dispositivo físico (para testar a câmera) ou o Simulador (use a opção "Escolher da galeria"), e rode com `Cmd+R`.

## Sobre o fluxo do app

1. Toque na moldura tracejada → escolha "Tirar foto" ou "Escolher da galeria"
2. Toque em "Identificar planta" — a foto é enviada em base64 para a API da Anthropic, pedindo uma resposta em JSON estruturado (nome popular, nome científico, família, cuidados, curiosidade, nota de toxicidade)
3. O resultado aparece como um cartão de espécime; identificações bem-sucedidas entram na tira de histórico da sessão (em memória — reinicia ao fechar o app)

## Próximos passos possíveis

- Persistir o histórico com SwiftData ou Core Data
- Adicionar localização (onde a planta foi fotografada) com Core Location + MapKit
- Cache de identificações repetidas para economizar chamadas de API
- Compartilhar o cartão de resultado como imagem (ShareLink)
