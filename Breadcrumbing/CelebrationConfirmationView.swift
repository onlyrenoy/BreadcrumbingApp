//
//  CelebrationConfirmationView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 15/10/25.
//

import SwiftUI

struct CelebrationConfirmationView: View {
    @Binding var isCelebtationComplete: Bool
    @Binding var BreadcrumbingViewModel: Bool
    
    var body: some View {
        ZStack {
            Color.clear
            VStack {
                Spacer()
                Text("Complete?")
                    .foregroundColor(Color.init(uiColor: SomeColors.gold))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .padding(.bottom)
                Spacer()
                HStack {
                    Button("Oh Yeah") {
                        isCelebtationComplete.toggle()
                        BreadcrumbingViewModel = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.init(uiColor: SomeColors.gold))
                    .fontWeight(.bold)
                    Spacer()
                    Button("Nu Huh") {
                        isCelebtationComplete.toggle()
                        BreadcrumbingViewModel = false
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.init(uiColor: SomeColors.gold))
                    .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(height: 300)
            .background(Color.init(uiColor: SomeColors.darkBlue))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            .shadow(color: .white.opacity(0.2), radius: 12, y: 8)
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    CelebrationConfirmationView(isCelebtationComplete: .constant(true), BreadcrumbingViewModel: .constant(true))
}
