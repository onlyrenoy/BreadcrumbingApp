//
//  BreadCrumbListView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI

struct BreadCrumbListView: View {
    @ObservedObject var viewModel: BreadcrumsListViewModel
    @EnvironmentObject var route: Router
    
    var body: some View {
        VStack {
            if viewModel.listOfBC.isEmpty {
                Text("Start your day".uppercased())
                    .monospaced()
            } else {
                ScrollView {
                    ForEach(viewModel.listOfBC, id: \.id) { bc in
                        BreadCrumbCell(breadCrumb: bc, celebrationCount: viewModel.celebrationCount)
                            .onTapGesture {
                                route.push(.detail(title: bc.title))
                            }
                    }
                    .padding(.bottom, 120)
                }
                .disabled(viewModel.disableScroll)
            }
        }
    }
}

#Preview {
    @ObservedObject var route: Router = .init()
    BreadCrumbListView(viewModel: BreadcrumsListViewModel())
        .environmentObject(route)
}