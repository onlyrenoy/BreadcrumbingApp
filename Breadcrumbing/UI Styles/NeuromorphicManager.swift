//
//  NeuromorphicManager.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 20/10/25.
//

import SwiftUI

struct Neuromorph: ViewModifier {
    @Binding var didPress: Bool
    @State var autoReset = false
    @State var simple = false // per botun che non fa nun
    @State var simpleConcave = false // per botun che non fa nun ed è concavo
    
    @State var cornerRadius: Int
    @State var onTapGesture: (() -> ())?
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
//                if !simple {
                    onTapGesture?()
                    withAnimation(.spring(duration: 0.2, bounce: 0.3, blendDuration: 0.1)) {
                        self.didPress.toggle()
                    }
                    if autoReset { self.didPress.toggle() }
//                }
            }
            .background {
                Color.neuBackground
            }
            .cornerRadius(CGFloat(cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                    .stroke(
                        LinearGradient(
                            colors: manageLinearGradient(),
                            startPoint: UnitPoint(x: 0.9, y: 0.9),
                            endPoint: UnitPoint(x: 0.9, y: 0.1))
                        , lineWidth: 1)
                    .fill(Color.clear)
            }
            .scaleEffect(self.didPress ? 0.95: 1)
            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: .neuBackground, radius: 15, x: -10, y: -10)
            
    }
    
    func manageLinearGradient() -> [Color] {
//        if simpleConcave {
//            return [.dropShadow, .dropLight]
//        } else
        if didPress {
            return [.dropShadow, .dropLight]
        } else { return [.dropLight, .dropShadow] }
    }
}

extension View {
    func neuro(concave: Binding<Bool> = .constant(true),
               simpleConcave: Bool = false,
               autoReset: Bool = true,
               cornerRadius: Int = 10,
               onTapGesture: (() -> ())? = nil) -> some View {
        let x = Neuromorph(didPress: concave,
                           autoReset: autoReset,
                           simpleConcave: simpleConcave,
                           cornerRadius: cornerRadius,
                           onTapGesture: onTapGesture)
        return modifier(x)
        }
    
}

struct NeuromorphicManager: View {
    @State var didPress = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Solo corner")
            }
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .neuro(cornerRadius: 100)
            .padding(.horizontal)
            
            VStack {
                Text("simple auto reset corner")
            }
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .neuro(simpleConcave: true,
                   autoReset: true,
                   cornerRadius: 100,
                   onTapGesture: nil)
            .padding(.horizontal)
            
            VStack {
                Text("Ooh")
            }
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .neuro(simpleConcave: false, autoReset: false, cornerRadius: 100, onTapGesture: nil)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NeuromorphicManager()
}
