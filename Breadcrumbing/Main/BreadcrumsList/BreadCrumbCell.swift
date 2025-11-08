//
//  BreadCrumbCell.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI
import Neuromorphic

struct BreadCrumbCell: View {
    var breadCrumb: BreadCrumb
    @State var celebrationCount: String
    
    var body: some View {
        VStack {
           RoundedRectangle(cornerRadius: 10)
               .fill(Color.clear)
               .frame(height: 110)
               .overlay {
                   HStack {
                       Text(breadCrumb.title)
                           .foregroundStyle(.black)
                           .padding(.leading)
                       Spacer()
                       Text(celebrationCount)
                           .foregroundStyle(Color(uiColor: SomeColors.gold))
                           .padding(.trailing)
                   }
               }
               
               .background { Color.clear }
               .neuro()
               .padding(.horizontal)
       }
    }
}

#Preview {
    BreadCrumbCell(breadCrumb: BreadCrumb(title: "Test"), celebrationCount: "★")
}
