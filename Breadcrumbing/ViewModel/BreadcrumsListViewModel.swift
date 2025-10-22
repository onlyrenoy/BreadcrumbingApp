//
//  BreadcrumsListViewModel.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI

@MainActor
class BreadcrumsListViewModel: ObservableObject {
    @Published var listOfBC: [BreadCrumb] = [] {
        didSet {
            print("BC Count:",listOfBC.count)
            print(listOfBC)
        }
    }
    @Published var selectedBC: BreadCrumb?
    @Published var showDetail = false
    @Published var disableScroll = false
    @Published var textfieldText = ""
    
    @Published var path: NavigationPath = NavigationPath()
    
    init() {
        listOfBC = BreadcrumsSaver.shared.listOfItems
    }
    
    @State var celebrationCount: String = BreadcrumsSaver.shared.currentBreadcrumb?.count ?? ""
    
    func showAddBreadcrumbAlert(_ val: Bool) {
        showDetail = val
        disableScroll = val
    }
    
    func onAppear() {
        BreadcrumsSaver.shared.readFromSaved()
        print("-------------------------")
        print("saver list:\n", BreadcrumsSaver.shared.listOfItems)
        print("///////////////////////")
        print("just list:\n", listOfBC)
        print("-------------------------")
        listOfBC = BreadcrumsSaver.shared.listOfItems
    }
}
