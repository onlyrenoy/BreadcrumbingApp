//
//  Routes.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//
import Foundation
import SwiftUI

enum Routes: Hashable {
    case home
    case detail(breadcrumb: BreadCrumbState)
}

@MainActor
class Router: ObservableObject {
    @Published var path: NavigationPath = .init()
    
    func push(_ route: Routes) {
        path.append(route)
    }
    
    @ViewBuilder
    func view(_ route: Routes) -> some View {
        Group {
            switch route {
            case .home: BreadcrumsList()
            case .detail(let bc): BreadCrumbDetailView(viewModel: BreadcrumbingViewModel(isRepcounter: bc.isTimer),
                                              breadcrumb: bc.breadcrumb)
            }
        }
        .environmentObject(self)
    }
}
