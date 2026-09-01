//
//  HistoryDetailView.swift
//  Herbario
//

import SwiftUI

struct HistoryDetailView: View {
    let item: IdentificationHistoryItem

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    image
                        .frame(maxWidth: .infinity)
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                        )

                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.scientificName)
                            .font(.title2.weight(.bold))
                            .italic()
                            .foregroundStyle(.white)
                        if let common = item.commonName {
                            Text(common)
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        HStack {
                            if let family = item.family {
                                Label("Família: \(family)", systemImage: "tree")
                                    .font(.footnote)
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            Spacer()
                            ScoreBadgeView(percent: item.scorePercent)
                        }
                        Text("Identificado em \(item.date.formatted(date: .long, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassCard()

                    if let response = item.decodedResponse, response.results.count > 1 {
                        Text("Outras possibilidades")
                            .font(.headline)
                            .foregroundStyle(.white)

                        VStack(spacing: 10) {
                            ForEach(Array(response.results.dropFirst().enumerated()), id: \.offset) { _, result in
                                ResultRowView(result: result, isTopResult: false)
                                    .padding(12)
                                    .glassCard(cornerRadius: 16)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Detalhe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private var image: some View {
        Group {
            if let uiImage = UIImage(data: item.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.herbGreen.opacity(0.15)
            }
        }
    }
}
