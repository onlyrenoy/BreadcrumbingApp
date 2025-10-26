//
//  BreadcrumsList.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 16/10/25.
//

import SwiftUI

struct BreadcrumsList: View {
    @Namespace var namespace
    
    @StateObject var viewModel = BreadcrumsListViewModel()
    
    @EnvironmentObject var route: Router
    
    var body: some View {
        ZStack {
            Color.neuBackground
                .ignoresSafeArea()
            
            BreadCrumbListView(viewModel: viewModel)
                .environmentObject(route)
            
            AddBreadCrumbButton(ns: namespace)
                .onTapGesture {
                    withAnimation {
                        viewModel.showAddBreadcrumbAlert(true)
                    }
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            
            if viewModel.showDetail {
                BreadCrumbCreationAlert(ns: namespace, viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    BreadcrumsList()
        .environmentObject(Router())
}
