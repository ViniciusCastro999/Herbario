import SwiftUI

struct ResultCardView: View {
    let image: UIImage
    let result: PlantIdentification

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            if result.encontrada {
                foundContent
            } else {
                Text(result.motivo ?? "Não foi possível identificar essa planta com clareza. Tente uma foto com mais luz, focando em uma folha ou flor inteira.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.herbInkSoft)
                    .padding(24)
            }
        }
        .background(Color.herbCard)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Color.herbHairline, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var foundContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Confiança da identificação: \(result.confianca ?? "—")")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.herbOchre)

                Text(result.nomeComum ?? "Planta não nomeada")
                    .font(.herbDisplay(26))
                    .foregroundStyle(Color.herbForestDeep)

                if let sci = result.nomeCientifico {
                    Text(sci)
                        .font(.herbItalic(16))
                        .foregroundStyle(Color.herbInkSoft)
                }
            }

            Divider().background(Color.herbHairline)

            HStack(alignment: .top, spacing: 24) {
                metaField(label: "Família", value: result.familia)
                metaField(label: "Tipo", value: result.tipo)
            }

            if let descricao = result.descricao, !descricao.isEmpty {
                Text(descricao)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.herbInk)
                    .lineSpacing(4)
            }

            if let cuidados = result.cuidados, !cuidados.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cuidados")
                        .font(.herbDisplay(16))
                        .foregroundStyle(Color.herbForestDeep)
                    ForEach(cuidados, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•").foregroundStyle(Color.herbMoss)
                            Text(item)
                                .font(.system(size: 14.5))
                                .foregroundStyle(Color.herbInk)
                        }
                    }
                }
            }

            if let curiosidade = result.curiosidade, !curiosidade.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Curiosidade")
                        .font(.herbDisplay(16))
                        .foregroundStyle(Color.herbForestDeep)
                    Text(curiosidade)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.herbInkSoft)
                        .lineSpacing(3)
                }
            }

            if let toxicidade = result.toxicidade, !toxicidade.isEmpty {
                Text(toxicidade)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.herbInkSoft)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.herbPaperDeep)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            }
        }
        .padding(24)
    }

    private func metaField(label: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(Color.herbInkSoft)
            Text(value ?? "—")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.herbInk)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
