//
//  ResultRowView.swift
//  Herbario
//
//  Linha de um candidato de identificação, com a foto de referência
//  devolvida pela própria API do PlantNet (quando disponível).
//

import SwiftUI

struct ResultRowView: View {
    let result: SpeciesResult
    let isTopResult: Bool

    var body: some View {
        HStack(spacing: 14) {
            thumbnail

            VStack(alignment: .leading, spacing: 3) {
                Text(result.species.scientificNameWithoutAuthor)
                    .font(.subheadline.weight(.semibold))
                    .italic()
                    .foregroundStyle(.white)
                if let common = result.primaryCommonName {
                    Text(common)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                if let family = result.species.family?.scientificNameWithoutAuthor {
                    Text("Família: \(family)")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            Spacer()

            ScoreBadgeView(percent: Int((result.score * 100).rounded()))
        }
        .padding(.vertical, 6)
        .padding(.horizontal, isTopResult ? 12 : 0)
        .background(
            isTopResult
                ? RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.herbGreen.opacity(0.08))
                : nil
        )
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let url = result.thumbnailImageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    fallbackIcon
                default:
                    ProgressView()
                }
            }
            .frame(width: 52, height: 52)
            .background(Color.herbGreen.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        } else {
            fallbackIcon
                .frame(width: 52, height: 52)
                .background(Color.herbGreen.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private var fallbackIcon: some View {
        Image(systemName: "leaf.fill")
            .font(.title3)
            .foregroundStyle(Color.herbGreen)
    }
}
