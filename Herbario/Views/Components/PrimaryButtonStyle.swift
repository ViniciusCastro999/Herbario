//
//  PrimaryButtonStyle.swift
//  Herbario
//
//  Estilos de botão do tema "vidro" (glassmorfismo) usados em todo o app.
//

import SwiftUI

/// Botão principal: pílula sólida verde com leve brilho, para a
/// ação mais importante da tela (ex.: "Adicionar foto").
struct GlassButtonStyle: ButtonStyle {
    var isDisabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(
                Capsule().fill(isDisabled ? Color.white.opacity(0.12) : Color.herbGreen)
            )
            .overlay(
                Capsule().strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: Color.herbGreen.opacity(isDisabled ? 0 : 0.5), radius: 14, y: 6)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// Botão secundário: vidro fosco translúcido, para ações de apoio
/// (ex.: "Tentar novamente").
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.herbGreen)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule().strokeBorder(Color.herbGreen.opacity(0.4), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
    }
}
