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
    
    @State private var refreshView = false
    
    var body: some View {
        VStack {
            if viewModel.listOfBC.isEmpty {
                Text("Start your day".uppercased())
                    .monospaced()
            } else {
                ScrollView {
                    ForEach(viewModel.listOfBC, id: \.breadcrumb.id) { bc in
                        BreadCrumbCell(breadCrumb: bc.breadcrumb,
                                       celebrationCount: bc.breadcrumb.count)
                            .onTapGesture {
                                route.push(.detail(breadcrumb: bc))
                            }
                    }
                    .id(refreshView)
                    .padding(.bottom, 120)
                }
                .disabled(viewModel.disableScroll)
            }
        }
        .onAppear {
            refreshView.toggle()
            viewModel.onAppear()
        }
    }
}

#Preview {
    @ObservedObject var route: Router = .init()
    BreadCrumbListView(viewModel: BreadcrumsListViewModel())
        .environmentObject(route)
}
