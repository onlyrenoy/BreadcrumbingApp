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
    @StateObject var vm = DailyArrayViewModel()
    
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

struct BreadCrumbState: Codable, Hashable {
    var breadcrumb: BreadCrumb
    var isTimer: Bool
}

class BreadcrumsSaver {
    static var shared = BreadcrumsSaver()
    
    let defaults = UserDefaults.standard
    
    var listOfItems: [BreadCrumbState] = []
    var currentBreadcrumb: BreadCrumb?
    
    init() {
        readFromSaved()
    }
    
    func update(_ item: BreadCrumb) {
        if let index = listOfItems.firstIndex(where: { $0.breadcrumb.id == item.id }) {
            listOfItems[index].breadcrumb = item
            
            save()
        }
    }
    
    func resetList() {
        listOfItems = []
        save()
    }
    
    fileprivate func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(listOfItems) {
            UserDefaults.standard.set(data, forKey: "breadcrumbs")
        }
    }
    
    func saveToList(_ breadcrumb: BreadCrumbState) {
        listOfItems.append(breadcrumb)
        
        save()
    }
    
    func readFromSaved() {
        if let data = UserDefaults.standard.data(forKey: "breadcrumbs"),
           let breadcrumbs = try? JSONDecoder().decode([BreadCrumbState].self, from: data) {
            listOfItems = breadcrumbs
        } else {
            listOfItems = []
        }
    }
}
