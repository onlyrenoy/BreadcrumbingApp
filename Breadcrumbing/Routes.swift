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
    case detail(title: String)
}

@MainActor
class Router: ObservableObject {
    @Published var path: NavigationPath = .init()
    
    func push(_ route: Routes) {
        print("Appending type:", type(of: route.hashValue))
        path.append(route)
    }
    
    @ViewBuilder
    func view(_ route: Routes) -> some View {
        Group {
            switch route {
            case .home: BreadcrumsList()
            case .detail(let title): ContentView(titleText: title)
            }
        }
        .environmentObject(self)
    }
}
