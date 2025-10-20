//
//  NeuromorphicManager.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 20/10/25.
//

import SwiftUI

struct Neuromorph: ViewModifier {
    @State var didPress = false
    @State var autoReset = false
    @State var cornerRadius: Int
    @State var onTapGesture: (() -> ())?
    
    func body(content: Content) -> some View {
        content
            .background {
                Color.neuBackground
//                LinearGradient(
//                    colors: didPress ? [.dropShadow, .dropLight] : [.dropLight, .dropShadow],
//                    startPoint: UnitPoint(x: 0.8, y: 0.1),
//                    endPoint: UnitPoint(x: 0.1, y: 0.9))
            }
            .cornerRadius(CGFloat(cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                    .stroke(
                        LinearGradient(
                            colors: !didPress ? [.dropShadow, .dropLight] : [.dropLight, .dropShadow],
                            startPoint: UnitPoint(x: 0.9, y: 0.9),
                            endPoint: UnitPoint(x: 0.9, y: 0.1))
                        , lineWidth: 1)
                    .fill(Color.clear)
                    
            }
            .onTapGesture {
                onTapGesture?()
                withAnimation(.spring(duration: 0.2, bounce: 0.3, blendDuration: 0.1)) {
                    self.didPress.toggle()
                }
                if autoReset { self.didPress.toggle() }
            }
            .scaleEffect(self.didPress ? 0.95: 1)
            .shadow(color: .dropShadow, radius: 20, x: 10, y: 10)
            .shadow(color: .neuBackground, radius: 20, x: -10, y: -10)
            
    }
}

extension View {
    func neuromorph(autoReset: Bool = true,cornerRadius: Int = 10, onTapGesture: (() -> ())? = nil) -> some View {
        let x = Neuromorph(autoReset: autoReset, cornerRadius: cornerRadius, onTapGesture: onTapGesture)
        return modifier(x)
        }
    
}

struct NeuromorphicManager: View {
    @State var didPress = false
    
    var body: some View {
        VStack {
            Text("Ooh")
        }
        .frame(height: 54)
        .frame(maxWidth: .infinity)
        .neuromorph(autoReset: false, cornerRadius: 100)
        .padding(.horizontal)
        
    }
}

#Preview {
    NeuromorphicManager()
}
