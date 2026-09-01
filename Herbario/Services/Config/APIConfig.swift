//
//  APIConfig.swift
//  Herbario
//
//  Lê configurações sensíveis a partir do Info.plist, que por sua vez
//  recebe o valor do Secrets.xcconfig (arquivo NÃO versionado).
//  Assim a chave de API nunca fica hardcoded no código-fonte que vai
//  para o GitHub.
//

import Foundation

enum APIConfig {

    static var plantNetAPIKey: String {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "PLANTNET_API_KEY") as? String,
            !key.isEmpty,
            key != "SUA_API_KEY_AQUI"
        else {
            assertionFailure(
                """
                PLANTNET_API_KEY não configurada.
                Copie Secrets.xcconfig.example para Secrets.xcconfig e informe sua chave
                (obtida em https://my.plantnet.org).
                """
            )
            return ""
        }
        return key
    }

    static let plantNetBaseURL = "https://my-api.plantnet.org/v2/identify"

    /// "all" identifica contra a flora mundial. Outras opções em
    /// https://my.plantnet.org/doc/newfloras
    static let plantNetProject = "all"
}
