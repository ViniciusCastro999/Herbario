//
//  IdentifyView.swift
//  Herbario
//
//  Tela inicial: minimalista, com visual de vidro sobre um fundo em
//  gradiente escuro. Só o essencial — escolher o órgão, e um único
//  botão para adicionar a foto (câmera ou galeria).
//

import SwiftUI

struct IdentifyView: View {
    @ObservedObject var viewModel: IdentifyViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 28) {
                        header

                        PhotoCaptureView(
                            image: viewModel.capturedImage,
                            onImagePicked: { viewModel.setImage($0) }
                        )

                        organCard

                        if case .failure(let message) = viewModel.state {
                            errorBanner(message)
                        }
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)

                if viewModel.state == .loading {
                    LoadingOverlay()
                }

                if viewModel.showSavedToast {
                    VStack {
                        Spacer()
                        SavedToastView()
                            .padding(.bottom, 24)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation { viewModel.showSavedToast = false }
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .animation(.easeInOut(duration: 0.2), value: viewModel.state)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showSavedToast)
            .navigationDestination(isPresented: $viewModel.navigateToResults) {
                ResultsView(viewModel: viewModel)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("Herbário")
                .font(.title.weight(.bold))
                .foregroundStyle(.white)
            Text("Identifique plantas por foto")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var organCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("O que você fotografou?")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))

            OrganPickerView(selectedOrgan: $viewModel.selectedOrgan)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }

    private func errorBanner(_ message: String) -> some View {
        VStack(spacing: 10) {
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .font(.footnote)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button("Tentar novamente") {
                viewModel.retryIdentify()
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(16)
        .glassCard(cornerRadius: 16)
    }
}
