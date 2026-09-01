//
//  MainTabView.swift
//  Herbario
//

import SwiftUI

struct MainTabView: View {
    @StateObject var identifyViewModel: IdentifyViewModel
    @StateObject var historyViewModel: HistoryViewModel

    init(identifyViewModel: IdentifyViewModel, historyViewModel: HistoryViewModel) {
        _identifyViewModel = StateObject(wrappedValue: identifyViewModel)
        _historyViewModel = StateObject(wrappedValue: historyViewModel)

        // Tab bar em vidro fosco, coerente com o resto do app.
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            IdentifyView(viewModel: identifyViewModel)
                .tabItem {
                    Label("Identificar", systemImage: "leaf.fill")
                }

            HistoryView(viewModel: historyViewModel)
                .tabItem {
                    Label("Histórico", systemImage: "clock.fill")
                }
        }
    }
}
