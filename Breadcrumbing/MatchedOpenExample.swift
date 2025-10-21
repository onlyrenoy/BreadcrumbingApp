//
//  MatchedOpenExample.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI

struct MatchedOpenExample: View {
    @Namespace private var ns
    @State private var selected: Item? = nil
    @State private var showDetail = false

    let items = (1...8).map { Item(id: $0, title: "Card \($0)") }

    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 16) {
                    ForEach(items) { item in
                        Card(item: item, ns: ns)
                            .onTapGesture {
                                selected = item
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                    showDetail = true
                                }
                            }
                    }
                }
                
                .padding()
            }

            // Detail overlay: exists in the SAME hierarchy during the animation
            if let item = selected, showDetail {
                Detail(item: item, ns: ns) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        showDetail = false
                    }
                    // delay nil so the small card can reappear after the animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        selected = nil
                    }
                }
                .zIndex(1)
                .transition(.identity) // keep geometry-driven transition only
            }
        }
    }
}

struct Card: View {
    let item: Item
    let ns: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.25))
                .matchedGeometryEffect(id: "bg-\(item.id)", in: ns)

            Text(item.title)
                .font(.headline)
                .padding(8)
                .matchedGeometryEffect(id: "title-\(item.id)", in: ns)
        }
        .frame(height: 120)
    }
}

struct Detail: View {
    let item: Item
    let ns: Namespace.ID
    var onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.blue.opacity(0.25))
                .matchedGeometryEffect(id: "bg-\(item.id)", in: ns)
                .ignoresSafeArea(edges: .bottom)

            VStack(alignment: .leading, spacing: 16) {
                Text(item.title)
                    .font(.largeTitle.bold())
                    .matchedGeometryEffect(id: "title-\(item.id)", in: ns)

                Text("Long detail content goes here…")
                    .font(.body)
                Spacer()
            }
            .padding()

            Button {
                onClose()
            } label: {
                Image(systemName: "xmark.circle.fill").font(.largeTitle)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture { onClose() }
        )
    }
}

struct Item: Identifiable, Hashable { let id: Int; let title: String }

#Preview(body: {
    MatchedOpenExample()
})
