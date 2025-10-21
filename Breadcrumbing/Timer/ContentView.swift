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
    
    @State private var ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @StateObject var viewModel: BreadcrumbingViewModel = BreadcrumbingViewModel()
    
    @State var showAlert = false
    @State var titleText: String
    
    var circleWidth: CGFloat = 260
    
    @EnvironmentObject var route: Router
    
    var body: some View {
        ZStack {
            Color.neuBackground.ignoresSafeArea()
            
            VStack {
                Text(titleText.uppercased())
                    .monospaced()
                    .foregroundStyle(Color(uiColor: SomeColors.gold))
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                Text(viewModel.celebrationCount)
                    .foregroundStyle(Color(uiColor: SomeColors.gold))
                    .font(.system(size: 40))
                    .frame(height: 90)
                
                Circle()
                    .stroke(Color.gray.opacity(0.05), lineWidth: 4)
                    .frame(width: circleWidth + 40)
                    .overlay {
                        Circle()
                            .fill(Color.neuBackground)
                            .frame(width: circleWidth)
                            .overlay {
                                CircularTimerWithDot(larghezza: circleWidth,
                                                     duration: TimeInterval(viewModel.remaining),
                                                     isRunning: $viewModel.isRunning)
                                .overlay {
                                    Text(viewModel.timeString())
                                        .monospaced()
                                        .font(.system(size: 56, weight: .bold, design: .rounded))
                                        .monospacedDigit()
                                        .padding(.horizontal)
                                        .foregroundStyle(viewModel.isRunning ? Color.init(uiColor: SomeColors.gold) : Color.init(uiColor: SomeColors.darkBlue))
                                }
                                
                            }
                            .neuro(concave: $viewModel.isRunning, cornerRadius: Int(circleWidth))
                            
                    }
                    .neuro(concave: $viewModel.isRunning, cornerRadius: Int(circleWidth))
                    .padding(.bottom, 30)
                
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 3)
                        .fill(Color.neuBackground)
                        .neuro()
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .overlay {
                            HStack(spacing: 20) {
                                ForEach(viewModel.fiveChances.indices, id: \.self) { val in
                                    if viewModel.fiveChances[val] == "" {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.neuBackground)
                                            .frame(width: 50, height: 50)
                                            .neuro(simpleConcave: true, cornerRadius: 13)
                                    } else {
                                        Text(viewModel.fiveChances[val] )
                                            .font(.system(size: 48))
                                            .frame(width: 50, height: 50)
                                            .neuro()
                                    }
                                }
                            }
                            .confetti(isPresented: $viewModel.showConfetti,
                                      animation: .fullWidthToDown,
                                      particles: [.arc, .heart, .star],
                                      duration: 3)
                            .confettiParticle(\.velocity, 300)
                        }
                }
                
                Spacer()
            
                Text(viewModel.isRunning ? "Cancel" : "Start")
                    .monospaced()
                    .font(.title2.weight(.semibold))
                    .frame(width: 180)
                    .padding(.vertical, 18)
                    .background(Color.neuBackground)
                    
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation { viewModel.toggleTimer() }
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    .foregroundStyle(viewModel.isRunning ? Color.init(uiColor: SomeColors.darkBlue) : Color.init(uiColor: SomeColors.gold))
                    
                    .neuro(concave: $viewModel.isRunning.inverted , cornerRadius: 40)
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
                        route.path.removeLast()
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
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ContentView(titleText:"Test")
    
}

extension Binding where Value == Bool {
    var inverted: Binding<Bool> {
        Binding(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
