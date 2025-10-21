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
    
    var celebrationCount: String = ""
}