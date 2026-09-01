//
//  PhotoCaptureView.swift
//  Herbario
//
//  Área de foto da tela inicial: preview em vidro + UM único botão
//  que abre as opções de Câmera ou Galeria (nunca dois botões
//  separados). Todo o estado de captura fica encapsulado aqui.
//

import SwiftUI
import PhotosUI

struct PhotoCaptureView: View {
    let image: UIImage?
    let onImagePicked: (UIImage) -> Void

    @State private var showSourceDialog = false
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    @State private var photoPickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 18) {
            previewSquare

            Button {
                showSourceDialog = true
            } label: {
                Label(image == nil ? "Adicionar foto" : "Trocar foto", systemImage: "camera.fill")
            }
            .buttonStyle(GlassButtonStyle())
        }
        .confirmationDialog("Adicionar foto", isPresented: $showSourceDialog, titleVisibility: .visible) {
            Button("Câmera") { showCamera = true }
            Button("Galeria") { showPhotosPicker = true }
            Button("Cancelar", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker { onImagePicked($0) }
                .ignoresSafeArea()
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    onImagePicked(uiImage)
                }
                photoPickerItem = nil
            }
        }
    }

    private var previewSquare: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 38))
                        .foregroundStyle(Color.herbGreen)
                    Text("Nenhuma foto ainda")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .frame(width: 240, height: 240)
            }
        }
        .glassCard(cornerRadius: 28)
    }
}
