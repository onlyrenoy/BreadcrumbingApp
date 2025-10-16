//
//  ContentView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 15/10/25.
//

import SwiftUI
import SPConfetti

enum SomeColors {
    static var gold: UIColor = UIColor(red: 0.99, green: 0.64, blue: 0.07, alpha: 1.00)
    static var gray: UIColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
    static var darkBlue: UIColor = UIColor(red: 0.08, green: 0.13, blue: 0.24, alpha: 1.00)
    static var bloodRed: UIColor = UIColor(red: 0.64, green: 0.09, blue: 0.10, alpha: 1.00)
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var viewModel = BreadcrumbingViewModel()
    
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            Color.init(uiColor: .black).ignoresSafeArea()
            if viewModel.isRunning {
                Color.init(uiColor: SomeColors.gray).ignoresSafeArea()
            } else if viewModel.isRunning && viewModel.remaining == 0 {
                Color(.systemBackground).ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                Text(viewModel.timeString())
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.horizontal)
                    .foregroundStyle(viewModel.isRunning ? Color.init(uiColor: SomeColors.darkBlue) : Color.init(uiColor: SomeColors.gold))
                
                Button(action: viewModel.toggleTimer) {
                    Text(viewModel.isRunning ? "Cancel" : "Start")
                        .font(.title2.weight(.semibold))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 18)
                        .background(viewModel.isRunning ? Color.init(uiColor: SomeColors.gold) : Color.init(uiColor: SomeColors.darkBlue))
                        .clipShape(Capsule())
                        .foregroundStyle(viewModel.isRunning ? Color.init(uiColor: SomeColors.darkBlue) : Color.init(uiColor: SomeColors.gold))
                }
                Spacer()
                
                HStack {
                    Text(viewModel.celebrations.joined(separator: " "))
                        .font(.system(size: 40))
                        .padding()
                        .confetti(isPresented: $viewModel.showConfetti,
                                  animation: .fullWidthToDown,
                                  particles: [.arc, .heart, .star],
                                  duration: 3)
                        .confettiParticle(\.velocity, 300)
                }
                .padding(.bottom)
            }
            
            if viewModel.timerDidEnd {
                CelebrationConfirmationView(isCelebtationComplete: $showAlert,
                                            BreadcrumbingViewModel: $viewModel.didCompleteCelebration)
                    .onChange(of: showAlert) { oldValue, newValue in
                        withAnimation {
                            viewModel.timerDidEnd = false
                        }
                        
                    }
                
            }
        }
        .onAppear {
            // Restore persisted endDate if any
            if let stored = UserDefaults.standard.object(forKey: "TimerEndDate") as? Date {
                viewModel.endDate = stored
                viewModel.isRunning = true
                // Recompute immediately
                viewModel.updateRemaining()
                if viewModel.remaining == 0 {
                    viewModel.finishIfNeeded()
                }
            }
            // Ask notification permission once (you can move this to a settings screen)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
        .onReceive(ticker) { _ in
            guard viewModel.isRunning else { return }
            viewModel.updateRemaining()
            
            if viewModel.remaining == 0 {
                withAnimation {
                    viewModel.finishIfNeeded()
                }
            }
        }
        .onChange(of: scenePhase) { newPhase, _ in
            // Re-sync when coming back to foreground
            if newPhase == .active {
                viewModel.updateRemaining()
                if viewModel.remaining == 0 {
                    withAnimation {
                        viewModel.finishIfNeeded()
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
