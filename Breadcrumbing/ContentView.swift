//
//  ContentView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 15/10/25.
//

import SwiftUI
import SPConfetti

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Binding var path: NavigationPath
    
    @State private var ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var viewModel: BreadcrumbingViewModel
    
    @State var showAlert = false
    @State var titleText: String
    
    var circleWidth: CGFloat = 130
    
    var body: some View {
        ZStack {
            Color.neuBackground.ignoresSafeArea()
            
            VStack {
                Text(titleText.uppercased())
                    .foregroundStyle(Color(uiColor: SomeColors.gold))
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                Spacer()
                
                Circle()
                    .fill(Color.neuBackground)
                    .neu(.raised,cornerRadius: circleWidth)
                    .frame(width: circleWidth)
                    .overlay {
                        Circle()
                            .stroke(Color.white ,lineWidth: 1)
                    }
                    .overlay(content: {
                        // CircularItem(width, duration, didStart)
                        CircularTimerWithDot(duration: TimeInterval(viewModel.totalSeconds),
                                             isRunning: $viewModel.isRunning)
                    })
                
                    .padding(.bottom, 30)
                
                
                
                Text(viewModel.timeString())
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.horizontal)
                    .foregroundStyle(viewModel.isRunning ? Color.init(uiColor: SomeColors.darkBlue) : Color.init(uiColor: SomeColors.gold))
                    .neu(.raised)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 0.5)
                            .fill(Color.clear)
                            
                    }
                    .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                    .padding(.bottom, 20)
                    
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
                
                Text(viewModel.celebrationCount)
                    .foregroundStyle(Color(uiColor: SomeColors.gold))
                    .font(.system(size: 40))
                    .frame(height: 100)
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 3)
                        .fill(Color.neuBackground)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.horizontal)
                        .overlay {
                            HStack(spacing: 20) {
 
                                ForEach(viewModel.fiveChances, id: \.self) { val in
                                    if val == "" {
                                        RoundedRectangle(cornerRadius: 8)
                                            .neu(.raised)
                                            .frame(width: 50, height: 50)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.neuBackground)
                                                    .stroke(Color.white, lineWidth: 0.5)
                                                    
                                            }
                                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                                            
                                    } else {
                                        Text(val)
                                            .font(.system(size: 48))
                                            .frame(width: 50, height: 50)
                                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                                    }
                                }
                            }
//                            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
//                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                            .confetti(isPresented: $viewModel.showConfetti,
                                      animation: .fullWidthToDown,
                                      particles: [.arc, .heart, .star],
                                      duration: 3)
                            .confettiParticle(\.velocity, 300)
                        }
                }
                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
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
            
            VStack {
                HStack {
                    Spacer()
                    Button("🅧") {
                        path.removeLast()
                    }
                    .foregroundStyle(Color(uiColor: SomeColors.gold))
                    .font(.system(size: 30))
                    .padding(.trailing, 16)
                    .padding(.top, 4)
                }
                Spacer()
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
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    @Previewable @StateObject var viewModel = BreadcrumbingViewModel()
    ContentView(path: .constant(NavigationPath()), titleText:"Test")
        .environmentObject(viewModel)
    
}
