//
//  SavedToastView.swift
//  Herbario
//

import SwiftUI

struct SavedToastView: View {
    var body: some View {
        Label("Salvo no histórico", systemImage: "checkmark.circle.fill")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Color.herbGreen, in: Capsule())
            .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
