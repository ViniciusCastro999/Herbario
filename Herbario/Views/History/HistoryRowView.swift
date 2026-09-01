//
//  HistoryRowView.swift
//  Herbario
//

import SwiftUI

struct HistoryRowView: View {
    let item: IdentificationHistoryItem

    var body: some View {
        HStack(spacing: 14) {
            thumbnail

            VStack(alignment: .leading, spacing: 4) {
                Text(item.scientificName)
                    .font(.subheadline.weight(.semibold))
                    .italic()
                    .foregroundStyle(.white)
                if let common = item.commonName {
                    Text(common)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                Text(item.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer()

            ScoreBadgeView(percent: item.scorePercent)
        }
        .padding(.vertical, 4)
    }

    private var thumbnail: some View {
        Group {
            if let uiImage = UIImage(data: item.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.herbGreen.opacity(0.15)
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
