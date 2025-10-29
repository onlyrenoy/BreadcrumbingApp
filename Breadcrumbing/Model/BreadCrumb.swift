//
//  BreadCrumb.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//


import SwiftUI

struct BreadCrumb: Codable, Identifiable, Hashable {
    var id = UUID()
    let title: String
    var count: String = ""
    var repCount: Int?
}
