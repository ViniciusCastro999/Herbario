//
//  ResultsView.swift
//  Herbario
//
//  Tela de resultados — chega via push (NavigationStack), nunca como
//  sheet. Mesmo fundo em gradiente + cards de vidro do resto do app.
//  O usuário toca na espécie correta e ela é salva no histórico;
//  a tela então volta sozinha para a tela inicial.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: IdentifyViewModel

    var body: some View {
        ZStack {
            AppBackground()

            if viewModel.results.isEmpty {
                EmptyStateView(
                    symbol: "questionmark.circle",
                    title: "Nenhum resultado",
                    message: "Não encontramos correspondências para essa foto. Volte e tente outro ângulo ou órgão da planta."
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Toque na espécie correta")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.7))

                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.results.enumerated()), id: \.element.id) { index, result in
                                Button {
                                    viewModel.select(result)
                                } label: {
                                    ResultRowView(result: result, isTopResult: index == 0)
                                        .padding(14)
                                        .glassCard(cornerRadius: 18)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Text("A pontuação indica o grau de confiança do PlantNet na correspondência. Ao selecionar, a identificação é salva no seu histórico.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(20)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Resultados")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
