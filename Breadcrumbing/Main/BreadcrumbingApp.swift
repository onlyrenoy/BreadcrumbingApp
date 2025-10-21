//
//  BreadcrumbingApp.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 15/10/25.
//

import SwiftUI

@main
struct BreadcrumbingApp: App {
    @StateObject var route: Router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $route.path) {
                route.view(.home)
                    .navigationDestination(for: Routes.self) { destination in
                        route.view(destination)
                    }
                    
            }
            .navigationBarBackButtonHidden()
            .environmentObject(route)
        }
    }
}
