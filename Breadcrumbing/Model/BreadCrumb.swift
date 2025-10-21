//
//  BreadCrumb.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI

struct BreadCrumb: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let count: Int = 0
}
