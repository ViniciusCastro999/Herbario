//
//  OrganPickerView.swift
//  Herbario
//
//  Grade de ícones em vidro para escolher qual parte da planta está
//  sendo fotografada. O selecionado ganha preenchimento verde com brilho.
//

import SwiftUI

struct OrganPickerView: View {
    @Binding var selectedOrgan: PlantOrgan

    private let columns = [GridItem(.adaptive(minimum: 66, maximum: 80), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(PlantOrgan.allCases) { organ in
                organButton(for: organ)
            }
        }
    }

    private func organButton(for organ: PlantOrgan) -> some View {
        let isSelected = organ == selectedOrgan
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedOrgan = organ
            }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: organ.symbolName)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : Color.herbGreen)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.herbGreen : Color.white.opacity(0.08))
                    )
                    .overlay(
                        Circle().strokeBorder(Color.white.opacity(isSelected ? 0 : 0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.herbGreen.opacity(isSelected ? 0.55 : 0), radius: 10, y: 4)

                Text(organ.displayName)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.55))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(.plain)
    }
}
