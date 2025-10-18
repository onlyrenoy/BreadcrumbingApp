//
//  CircularTimerView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 18/10/25.
//
import SwiftUI
import Combine

struct CircularTimerWithDot: View {
    //My
    var larghezza: CGFloat = 130
    @State var duration: TimeInterval
    
    
    let tick: TimeInterval = 1/60

    @State private var elapsed: TimeInterval = 0
    @Binding var isRunning: Bool
    @State private var cancellable: Cancellable?

    private var progress: CGFloat {
        guard duration > 0 else { return 1 }
        return min(1, CGFloat(elapsed / duration))
    }

    private var remaining: Int {
        max(0, Int(ceil(duration - elapsed)))
    }

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Track
                Circle()
                    .stroke(.gray.opacity(0.1), lineWidth: 16)
                    .overlay {
                        // Moving dot along the circumference
                        GeometryReader { geo in
                            let size = min(geo.size.width, geo.size.height)
                            let radius = size / 2
                            // Convert progress [0,1] into angle in radians, starting at top (-90°)
                            let angle = Double(progress) * 2.0 * .pi - .pi/2

                            // Dot position
                            let x = radius + cos(angle) * (radius)  // -8 so the dot sits on the stroke
                            let y = radius + sin(angle) * (radius)

                            Circle()
                                .foregroundStyle(Color.neuBackground)
                                .frame(width: 16, height: 16)
                                .neu(.raised)
                                .position(x: x, y: y)
                                .shadow(radius: 2)
                                .animation(.linear(duration: tick), value: progress)
                        }
                        .allowsHitTesting(false)

                    }

                            }
            .frame(width: larghezza)
            .onChange(of: isRunning) { old, new in
                if new {
                    start()
                } else {
                    reset()
                }
            }
        }
        .padding()
        .onDisappear { pause() }
    }

    // MARK: - Controls
    func start() {
//        guard !isRunning else { return }
        isRunning = true

        cancellable = Timer.publish(every: tick, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                elapsed += tick
                if elapsed >= duration {
                    elapsed = duration
                    pause()
                }
            }
    }

    private func pause() {
        isRunning = false
        cancellable?.cancel()
        cancellable = nil
    }

    private func reset() {
        pause()
        elapsed = 0
    }
}

#Preview { CircularTimerWithDot(duration: 10, isRunning: .constant(false)) }
