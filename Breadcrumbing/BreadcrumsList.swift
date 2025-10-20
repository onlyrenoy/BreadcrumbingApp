//
//  BreadcrumsList.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 16/10/25.
//

import SwiftUI

struct BreadCrumb: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let count: Int = 0
}

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.3)
    static let dropLight = Color(hex: "ffffff")
}


struct BreadcrumsList: View {
    @Namespace var namespace
    @State var listOfBC: [BreadCrumb] = [BreadCrumb(title: "test")]
    @State var selectedBC: BreadCrumb?
    @State var showDetail = false
    @State var disableScroll = false
    @State var text = ""
    
    @State var path: NavigationPath = .init()
    
    @StateObject var viewModel = BreadcrumbingViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.neuBackground
                    .ignoresSafeArea()
                listOfBreadcrumbs()
                
                addButton()
                
                if showDetail {
                    createBredcrumb()
                }
            }
        }
    }
    
    fileprivate func breadcrumbCell(_ bc: BreadCrumb) -> some View {
        return VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .frame(height: 110)
                .overlay {
                    HStack {
                        Text(bc.title)
                            .foregroundStyle(.black)
                            .padding(.leading)
                        Spacer()
                        Text(viewModel.celebrationCount)
                            .foregroundStyle(Color(uiColor: SomeColors.gold))
                            .padding(.trailing)
                    }
                }
                .neuromorph(autoReset: true, onTapGesture: {
                    path.append("detail")
                })
                .padding(.horizontal)
                .navigationDestination(for: String.self) { val in
                    ContentView(path: $path, titleText: bc.title)
                        .environmentObject(viewModel)
                }
                
                
        }
        
    }
    
    @State private var isPressed: Bool = false
    
    fileprivate func addButton() -> some View {
        return VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.clear)
                .frame(height: 80)
                .overlay {
                    Text("✚")
                        .foregroundStyle(.black)
                        .font(.largeTitle)
                    
                }
                .neuromorph(autoReset: true, onTapGesture: {
                    withAnimation {
                        showDetail = true
                        disableScroll = true
                    }
                })
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
        }
        .matchedGeometryEffect(id: "AddBreadCrumb", in: namespace)
    }
    
    fileprivate func listOfBreadcrumbs() -> some View {
        return VStack {
            ScrollView {
                ForEach(listOfBC) { bc in
                    breadcrumbCell(bc)
                }
                .padding(.bottom, 120)
            }
            .disabled(disableScroll)
//            .blur(radius: showDetail ? 2 : 0)
            .overlay {
                if showDetail {
//                    Color.black.opacity(0.18)
//                        .ignoresSafeArea()
//                        .transition(.opacity)
//                        .allowsHitTesting(false)
                }
            }
        }
    }

    fileprivate func createBredcrumb() -> some View {
        
        return VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .overlay {
                    VStack {
                        Text("Breadcrumb")
                            .foregroundStyle(.black)
                        TextField("some", text: $text)
                            .padding()
                            .border(.background)
                            .cornerRadius(20)
                            .neuromorph(autoReset: true)
                            .padding()
                        
                        HStack {
                            Button("OK") {
                                if !text.isEmpty {
                                    listOfBC.append(BreadCrumb(title: text))
                                }
                                
                                withAnimation {
                                    text = ""
                                    showDetail = false
                                    disableScroll = false
                                    
                                }
                            }
                            .padding()
                            .neuromorph()
                            
                            
                            Spacer()
                            Button("Cancel") {
                                withAnimation {
                                    text = ""
                                    showDetail = false
                                    disableScroll = false
                                }
                            }
                            .padding()
                            .neuromorph()
                        }
                        .padding()
                    }
                }
                .onTapGesture {
                    withAnimation {
                        text = ""
                        showDetail = false
                        disableScroll = false
                    }
                    
                }
        }
        .frame(height: 240)
        .neuromorph()
        .matchedGeometryEffect(id: "AddBreadCrumb", in: namespace)
        .padding(.horizontal, 45)
        .zIndex(1)
    }
    
    
}
/*
 item
 .fill(Color.neuBackground)
 
 container
 .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
 .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
 */
#Preview {
    BreadcrumsList()
}


extension Color {
    init(hex: String) {
        // Remove "#" if present
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit, e.g. F0A)
            (a, r, g, b) = (255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17)
        case 6: // RGB (24-bit, e.g. FF00AA)
            (a, r, g, b) = (255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF)
        case 8: // ARGB (32-bit, e.g. FF00AAFF)
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 0, 0, 0) // fallback = black
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
