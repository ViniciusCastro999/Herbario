import SwiftUI

struct CaptureCard: View {
    let image: UIImage?
    let onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.herbCard)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .strokeBorder(Color.herbMoss, style: StrokeStyle(lineWidth: 1.4, dash: [6, 5]))

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "camera")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(Color.herbMoss)
                    Text("Toque para fotografar ou enviar uma imagem")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.herbInk)
                        .multilineTextAlignment(.center)
                    Text("JPG ou PNG")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.herbInkSoft)
                }
                .padding(32)
            }
        }
        .frame(height: 300)
        .contentShape(RoundedRectangle(cornerRadius: 4))
        .onTapGesture(perform: onTap)
    }
}
