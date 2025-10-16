//
//  BreadcrumbingViewModel.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 15/10/25.
//

import Foundation
import UserNotifications
import AudioToolbox

@MainActor
class BreadcrumbingViewModel: ObservableObject {
    
    @Published var totalSeconds: Int = 2// 5 * 60
    @Published var remaining: Int = 2//5 * 60
    @Published var isRunning: Bool = false
    @Published var endDate: Date? = nil
    
    @Published var celebrations: [String] = []
    @Published var showConfetti = false
    
    @Published var timerDidEnd = false {
        didSet {
            if didCompleteCelebration {
                self.celebrations.append("✅")
                showConfetti = true
                vibrateFor3Seconds()
            }
            
            didCompleteCelebration = false
        }
    }
    
    @Published var didCompleteCelebration = false
    
    // MARK: - UI Actions
    
     func toggleTimer() {
        if isRunning {
            cancelTimer()
        } else {
            startTimer()
        }
    }
    
    // MARK: - Timer Logic
    
     func startTimer() {
        let target = Date().addingTimeInterval(TimeInterval(totalSeconds))
        endDate = target
        isRunning = true
        scheduleDoneNotification(at: target)
        UserDefaults.standard.set(target, forKey: "TimerEndDate")
        updateRemaining()
    }
    
     func cancelTimer() {
        isRunning = false
        endDate = nil
        remaining = totalSeconds
        UserDefaults.standard.removeObject(forKey: "TimerEndDate")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TimerDone"])
    }
    
     func updateRemaining() {
        guard let end = endDate else {
            remaining = totalSeconds
            return
        }
        let diff = Int(max(0, end.timeIntervalSinceNow.rounded(.down)))
        remaining = diff
    }
    
     func finishIfNeeded() {
        guard isRunning else { return }
        isRunning = false
        endDate = nil
        UserDefaults.standard.removeObject(forKey: "TimerEndDate")
        // We already fired a local notification if we were in background.
        // If the app is active/foreground now, give a long tactile confirmation:
         
         timerDidEnd = true
         
         vibrateFor3Seconds()

    }
    // MARK: - Notification
    
     func scheduleDoneNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Timer finished"
        content.body = "Your countdown is done."
        content.sound = .default // System will vibrate/buzz per user settings
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, date.timeIntervalSinceNow), repeats: false)
        let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
        
        // Clear any previous scheduled one, then add
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TimerDone"])
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Helpers
    
    func vibrateFor3Seconds() {
        let total: TimeInterval = 3.0
        let interval: TimeInterval = 0.4
        var elapsed: TimeInterval = 0
        
        // Pulse repeatedly to approximate a long vibration
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            elapsed += interval
            if elapsed >= total {
                t.invalidate()
            }
        }
    }
    
    func timeString() -> String {
        let m = remaining / 60
        let s = remaining % 60
        return String(format: "%02d:%02d", m, s)
    }
}
