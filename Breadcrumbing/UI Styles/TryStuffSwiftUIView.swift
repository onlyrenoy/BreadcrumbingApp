//
//  TryStuffSwiftUIView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 16/10/25.
//

import SwiftUI

// MARK: - Model
struct AppCard: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let color: Color
}

// MARK: - Demo Data
let demoCards: [AppCard] = [
    .init(title: "Focus",  color: .blue),
    .init(title: "Tracks", color: .green),
    .init(title: "Notes",  color: .orange),
    .init(title: "Diet",   color: .pink),
    .init(title: "Run",    color: .purple),
    .init(title: "Read",   color: .teal)
]

// MARK: - ContentView
struct TryStuffSwiftUIView: View {
    @Namespace private var ns
        @State private var selected: AppCard? = nil
        @State private var showDetail = false
        @State private var disableScroll = false

        var body: some View {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 16)], spacing: 16) {
                        ForEach(demoCards) { card in
                            VStack(alignment: .leading, spacing: 8) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(card.color.gradient)
                                    .frame(height: 110)
                                    .matchedGeometryEffect(id: "image-\(card.id)", in: ns)
                                Text(card.title)
                                    .font(.headline)
                                    .matchedGeometryEffect(id: "title-\(card.id)", in: ns)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
                                    .matchedGeometryEffect(id: "card-\(card.id)", in: ns)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                    selected = card
                                    showDetail = true
                                    disableScroll = true
                                }
                            }
                        }
                    }
                    .padding(16)
                }
                .disabled(disableScroll)
                .blur(radius: showDetail ? 2 : 0)
                .overlay {
                    if showDetail {
                        Color.black.opacity(0.18)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .allowsHitTesting(false)
                    }
                }

                if let selected, showDetail {
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(selected.color.gradient)
                            .frame(height: 280)
                            .matchedGeometryEffect(id: "image-\(selected.id)", in: ns)

                        VStack(alignment: .leading, spacing: 16) {
                            Text(selected.title)
                                .font(.largeTitle.bold())
                                .matchedGeometryEffect(id: "title-\(selected.id)", in: ns)
                            Text("Detail content…")
                            Spacer(minLength: 0)
                        }
                        .padding(20)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 28).fill(Color(.systemBackground))
                            .ignoresSafeArea()
                            .matchedGeometryEffect(id: "card-\(selected.id)", in: ns)
                    )
                    .zIndex(1)
                    .transition(.identity)
                }
            }
            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: showDetail)
            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: selected)
        }
}

// MARK: - Card Cell (List State)
struct CardCell: View {
    let card: AppCard
    let ns: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(card.color.gradient)
                .frame(height: 110)
                .overlay(alignment: .bottomLeading) {
                    Text(card.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(12)
                        .matchedGeometryEffect(id: "title-\(card.id)", in: ns) // shared title
                }
                .matchedGeometryEffect(id: "image-\(card.id)", in: ns) // shared visual
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
    }
}

// MARK: - Detail Overlay (Expanded State)
struct DetailOverlay: View {
    let card: AppCard
    let ns: Namespace.ID
    let onClose: () -> Void

    @State private var showBody = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Shared header container
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(card.color.gradient)
                        .frame(height: 280)
                        .overlay(alignment: .bottomLeading) {
                            Text(card.title)
                                .font(.largeTitle.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(20)
                                .matchedGeometryEffect(id: "title-\(card.id)", in: ns)
                        }
                        .matchedGeometryEffect(id: "image-\(card.id)", in: ns)
                        .matchedGeometryEffect(id: "card-\(card.id)", in: ns)

                    // Body content (appears after header starts animating)
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(0..<12) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.secondary.opacity(0.15))
                                .frame(height: 56)
                                .overlay(alignment: .leading) {
                                    Text("Row \(i + 1)")
                                        .padding(.horizontal, 16)
                                }
                        }
                    }
                    .padding(20)
                    .opacity(showBody ? 1 : 0)
                    .offset(y: showBody ? 0 : 16)
                    .animation(.easeOut(duration: 0.25).delay(0.08), value: showBody)
                }
            }
            .ignoresSafeArea(edges: .top)
            .onAppear { showBody = true }
            .onDisappear { showBody = false }

            // Close button
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .black.opacity(0.35))
                    .padding(14)
            }
            .accessibilityLabel("Close")
        }
        
        .background(
            // background surface behind the card as it expands
            Color(.systemBackground)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    TryStuffSwiftUIView()
}
