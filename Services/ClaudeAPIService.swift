import Foundation
import UIKit

enum PlantIDError: LocalizedError {
    case invalidImage
    case missingAPIKey
    case requestFailed(String)
    case emptyResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Não foi possível preparar a imagem para envio."
        case .missingAPIKey:
            return "Configure sua chave da API da Anthropic antes de usar o app (veja o README)."
        case .requestFailed(let detail):
            return "Falha na identificação (\(detail)). Tente novamente."
        case .emptyResponse:
            return "A resposta da IA veio vazia."
        case .decodingFailed:
            return "Não foi possível interpretar a resposta da IA."
        }
    }
}

enum ClaudeAPIService {

    static func identify(image: UIImage) async throws -> PlantIdentification {
        guard Config.hasValidAPIKey else {
            throw PlantIDError.missingAPIKey
        }

        guard let jpegData = image.jpegData(compressionQuality: 0.85) else {
            throw PlantIDError.invalidImage
        }
        let base64Image = jpegData.base64EncodedString()

        var request = URLRequest(url: URL(string: "https://api.anthropic.com/v1/messages")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": "claude-sonnet-5",
            "max_tokens": 1000,
            "thinking": [
                "type": "disabled"
            ],
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "image",
                            "source": [
                                "type": "base64",
                                "media_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ],
                        [
                            "type": "text",
                            "text": identificationPrompt
                        ]
                    ]
                ]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw PlantIDError.requestFailed("código \(code)")
        }

        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let content = json["content"] as? [[String: Any]],
            let textBlock = content.first(where: { ($0["type"] as? String) == "text" }),
            let text = textBlock["text"] as? String
        else {
            throw PlantIDError.emptyResponse
        }

        let cleaned = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let cleanedData = cleaned.data(using: .utf8) else {
            throw PlantIDError.decodingFailed
        }

        do {
            return try JSONDecoder().decode(PlantIdentification.self, from: cleanedData)
        } catch {
            throw PlantIDError.decodingFailed
        }
    }

    private static let identificationPrompt = """
    Você é um botânico experiente. Analise a foto da planta e responda APENAS \
    com um objeto JSON válido, sem markdown, sem crases, sem texto antes ou depois. \
    Use este formato exato:

    {
      "encontrada": true,
      "nome_comum": "nome popular em português",
      "nome_cientifico": "Gênero espécie",
      "familia": "família botânica",
      "tipo": "ex: suculenta, árvore, erva, trepadeira, samambaia",
      "confianca": "Alta, Média ou Baixa",
      "descricao": "2 a 3 frases descrevendo as características visíveis na foto",
      "cuidados": ["cuidado 1", "cuidado 2", "cuidado 3"],
      "curiosidade": "um fato interessante sobre a planta",
      "toxicidade": "breve nota sobre toxicidade, ou 'Não é conhecida como tóxica'"
    }

    Se a imagem não mostrar uma planta claramente, responda:
    {
      "encontrada": false,
      "motivo": "explicação breve e gentil do que impede a identificação, com uma dica de como fotografar melhor"
    }
    """
}
