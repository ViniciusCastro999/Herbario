import SwiftUI

extension Color {
    // Paper & ink
    static let herbPaper = Color(hex: "F3EEDD")
    static let herbPaperDeep = Color(hex: "EAE2C8")
    static let herbInk = Color(hex: "211D14")
    static let herbInkSoft = Color(hex: "4B4636")

    // Botanical accents
    static let herbForest = Color(hex: "1E3A2B")
    static let herbForestDeep = Color(hex: "14281D")
    static let herbMoss = Color(hex: "6B8A5A")
    static let herbOchre = Color(hex: "B8863C")
    static let herbRust = Color(hex: "9C4A2D")
    static let herbHairline = Color(hex: "D3C7A6")
    static let herbCard = Color(hex: "FBF8EF")

    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

extension Font {
    /// Editorial serif for names and headings — uses the system serif (New York)
    /// so no custom font file needs to be bundled.
    static func herbDisplay(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func herbItalic(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .serif).italic()
    }
}
