//
//  AddBreadCrumbButton.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI

struct AddBreadCrumbButton: View {
    let ns: Namespace.ID
    
    var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.clear)
                .frame(height: 80)
                .overlay {
                    Text("✚")
                        .foregroundStyle(.black)
                        .font(.largeTitle)
                    
                }
                .neuro(autoReset: true)
                .background { Color.clear }
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
        }
        .matchedGeometryEffect(id: "AddBreadCrumb", in: ns)
    }
}

#Preview {
    @Previewable @Namespace var test
    AddBreadCrumbButton(ns: test)
}
