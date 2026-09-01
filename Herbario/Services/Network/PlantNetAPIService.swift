//
//  PlantNetAPIService.swift
//  Herbario
//
//  Implementação concreta que fala com a API do PlantNet:
//  POST https://my-api.plantnet.org/v2/identify/{project}?api-key=...
//  Documentação: https://my.plantnet.org/doc/getting-started/introduction
//

import UIKit

final class PlantNetAPIService: PlantIdentificationServicing {

    private let session: URLSession
    private let baseURL: String
    private let project: String
    private let apiKey: String

    init(
        session: URLSession = .shared,
        baseURL: String = APIConfig.plantNetBaseURL,
        project: String = APIConfig.plantNetProject,
        apiKey: String = APIConfig.plantNetAPIKey
    ) {
        self.session = session
        self.baseURL = baseURL
        self.project = project
        self.apiKey = apiKey
    }

    func identify(images: [PlantImageInput]) async throws -> PlantIdentificationResponse {
        guard !apiKey.isEmpty else { throw NetworkError.missingAPIKey }
        guard let url = URL(string: "\(baseURL)/\(project)?api-key=\(apiKey)") else {
            throw NetworkError.invalidURL
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try buildMultipartBody(images: images, boundary: boundary)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError where [.notConnectedToInternet, .networkConnectionLost, .timedOut].contains(urlError.code) {
            throw NetworkError.noConnection
        } catch {
            throw NetworkError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let message = (try? JSONDecoder().decode(PlantNetErrorBody.self, from: data))?.message
            throw NetworkError.server(statusCode: httpResponse.statusCode, message: message)
        }

        do {
            return try JSONDecoder().decode(PlantIdentificationResponse.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    // MARK: - Multipart builder

    private func buildMultipartBody(images: [PlantImageInput], boundary: String) throws -> Data {
        var body = Data()
        let lineBreak = "\r\n"

        func appendField(name: String, value: String) {
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\(lineBreak)\(lineBreak)")
            body.append("\(value)\(lineBreak)")
        }

        for input in images {
            appendField(name: "organs", value: input.organ.apiValue)
        }

        for (index, input) in images.enumerated() {
            guard let jpegData = input.image.jpegData(compressionQuality: 0.85) else {
                throw NetworkError.invalidImage
            }
            let filename = "image_\(index).jpg"
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(filename)\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)")
            body.append(jpegData)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

private struct PlantNetErrorBody: Decodable {
    let statusCode: Int?
    let error: String?
    let message: String?
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
