//
//  Theme.swift
//  Herbario
//
//  Fundo em gradiente escuro (tema "floresta") + modificador de
//  glassmorfismo reutilizado em todas as telas do app.
//

import SwiftUI

/// Fundo padrão do app: gradiente escuro esverdeado com blobs
/// desfocados para dar profundidade — substitui qualquer fundo branco.
struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.08, blue: 0.06),
                    Color(red: 0.05, green: 0.15, blue: 0.11),
                    Color(red: 0.03, green: 0.11, blue: 0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.herbGreen.opacity(0.35))
                .frame(width: 300, height: 300)
                .blur(radius: 100)
                .offset(x: -130, y: -280)

            Circle()
                .fill(Color.teal.opacity(0.22))
                .frame(width: 280, height: 280)
                .blur(radius: 110)
                .offset(x: 150, y: 320)
        }
        .ignoresSafeArea()
    }
}

/// Painel "vidro fosco" — material translúcido com borda sutil e sombra,
/// usado em todos os cards, listas e botões secundários do app.
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 22

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 18, y: 10)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 22) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }

    /// Deixa listas transparentes para o AppBackground aparecer atrás,
    /// com cada linha estilizada como um card de vidro.
    func glassListStyle() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}
