//
//  DailyArrayViewModel.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 26/10/25.
//


import Foundation
import SwiftUI

@MainActor
class DailyArrayViewModel: ObservableObject {
    @Published var items: [String] = []

    private let lastResetKey = "lastResetDate"

    init() {
        resetIfNewDay()
    }

    // MARK: - Reset Logic
    func resetIfNewDay() {
        let now = Date()
        let calendar = Calendar.current
        let defaults = UserDefaults.standard

        if let lastReset = defaults.object(forKey: lastResetKey) as? Date {
            if !calendar.isDate(now, inSameDayAs: lastReset) {
                resetItems()
            }
        } else {
            defaults.set(now, forKey: lastResetKey)
        }
    }

    // MARK: - Reset Array
    func resetItems() {
        items.removeAll()
        print("✅ Array reset at start of new day")
        BreadcrumsSaver.shared.resetList()
        UserDefaults.standard.set(Date(), forKey: lastResetKey)
    }
}
