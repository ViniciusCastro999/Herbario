//
//  LoadingOverlay.swift
//  Herbario
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .tint(.white)
                .scaleEffect(1.3)
            Text("Identificando planta…")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white)
        }
        .padding(28)
        .background(.black.opacity(0.75), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}
