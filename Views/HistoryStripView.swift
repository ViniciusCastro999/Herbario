import SwiftUI

struct HistoryStripView: View {
    let entries: [HistoryEntry]
    let onSelect: (HistoryEntry) -> Void

    var body: some View {
        if !entries.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                Text("Coletadas nesta sessão")
                    .font(.herbDisplay(18))
                    .foregroundStyle(Color.herbForestDeep)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(entries) { entry in
                            Button {
                                onSelect(entry)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Image(uiImage: entry.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 92, height: 92)
                                        .clipShape(RoundedRectangle(cornerRadius: 3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.herbHairline, lineWidth: 1)
                                        )
                                    Text(entry.result.nomeComum ?? "—")
                                        .font(.system(size: 11.5))
                                        .foregroundStyle(Color.herbInkSoft)
                                        .lineLimit(2)
                                        .frame(width: 92, alignment: .leading)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
