//
//  ScoreBadgeView.swift
//  Herbario
//

import SwiftUI

struct ScoreBadgeView: View {
    let percent: Int

    private var color: Color {
        switch percent {
        case 70...: return .herbGreen
        case 40..<70: return .orange
        default: return .red
        }
    }

    var body: some View {
        Text("\(percent)%")
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color, in: Capsule())
    }
}
