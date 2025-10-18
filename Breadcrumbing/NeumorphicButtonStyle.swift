//
//  NeumorphicButtonStyle.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 17/10/25.
//
import SwiftUI

enum NeuStyle { case raised, inset, concave, convex }

struct NeuModifier: ViewModifier {
    @Environment(\.colorScheme) private var scheme

    var style: NeuStyle
    var cornerRadius: CGFloat = 18
    /// Set your base surface once; use same color for screen background.
    var baseColorLight = Color.neuBackground // #E9EEF3
    var baseColorDark  = Color(red: 0.11, green: 0.12, blue: 0.14) // #1C1F24
    var padding: Int
    
    func body(content: Content) -> some View {
        let base = scheme == .dark ? baseColorDark : baseColorLight

        // Tuned shadows for light/dark
        let lightShadow = (scheme == .dark ? Color.white.opacity(0.01) : Color.white.opacity(0.3))
        let darkShadow  = (scheme == .dark ? Color.black.opacity(0.6)  : Color.black.opacity(0.2))

        return content
            .padding(0)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(base)
                    .overlay(overlayFor(style: style, base: base))
                    .shadow(color: lightShadow, radius: 12, x: style == .inset ? 0 : -6, y: style == .inset ? 0 : -6)
                    .shadow(color: darkShadow,  radius: 12, x: style == .inset ? 0 :  6, y: style == .inset ? 0 :  6)
            )
    }

    @ViewBuilder
    private func overlayFor(style: NeuStyle, base: Color) -> some View {
        switch style {
        case .raised:
            EmptyView() // outer shadows already give depth

        case .inset:
            // Light inner rim (top-left)
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .blur(radius: 2)
                .offset(x: -1, y: -1)
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(colors: [.white, .clear],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                )
                .overlay(
                    // Dark inner rim (bottom-right)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(Color.black.opacity(0.7), lineWidth: 2)
                        .blur(radius: 15)
                        .offset(x: 1, y: 1)
                        .mask(
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [.clear, .black.opacity(0.6)],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        )
                )

        case .concave:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.14), Color.black.opacity(0.12)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )

        case .convex:
            RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                .fill(
                    LinearGradient(
                        colors: [Color.black.opacity(0.04), Color.white.opacity(0.04)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
        }
    }
}

extension View {
    func neu(_ style: NeuStyle,
             cornerRadius: CGFloat = 18, padding: Int = 0) -> some View {
        modifier(NeuModifier(style: style,
                             cornerRadius: cornerRadius,
                             padding: padding))
    }
}


struct NeuDemo: View {
    var body: some View {
        // Screen surface (must match the base in the modifier)
        let surface = Color(red: 0.91, green: 0.94, blue: 0.95) // #E9EEF3

        return ZStack {
            surface.ignoresSafeArea()

            VStack(spacing: 28) {

                Text("Raised Card")
                    .neu(.raised)

                Text("Pressed Button")
                    .neu(.inset)

                Text("Convex Surface")
                    .neu(.convex)

                Text("Concave Surface")
                    .neu(.concave)
            }
            .padding(32)
        }
    }
}

#Preview {
    // If you don’t want an Asset color, replace Color("NeuBase") with:
    // let base = Color(.sRGB, red: 0.92, green: 0.95, blue: 0.97, opacity: 1)
    NeuDemo()
}
