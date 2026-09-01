//
//  HistoryView.swift
//  Herbario
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if viewModel.isEmpty {
                    EmptyStateView(
                        symbol: "clock.arrow.circlepath",
                        title: "Histórico vazio",
                        message: "As plantas que você identificar vão aparecer aqui."
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.items) { item in
                                NavigationLink(value: item) {
                                    HistoryRowView(item: item)
                                        .padding(14)
                                        .glassCard(cornerRadius: 18)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.delete(item)
                                    } label: {
                                        Label("Remover", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("Histórico")
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: IdentificationHistoryItem.self) { item in
                HistoryDetailView(item: item)
            }
            .onAppear { viewModel.load() }
        }
    }
}
