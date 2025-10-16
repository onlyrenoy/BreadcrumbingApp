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

struct BreadcrumsList: View {
    @Namespace var namespace
    @State var listOfBC: [BreadCrumb] = []
    @State var selectedBC: BreadCrumb?
    @State var showDetail = false
    @State var disableScroll = false
    @State var text = "r"
    
    @State var path: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                listOfBreadcrumbs()
                
                addButton()
                
                if showDetail {
                    createBredcrumb()
                }
            }
        }
    }
    
    fileprivate func breadcrumbCell(_ bc: BreadCrumb) -> VStack<some View> {
        return VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 110)
                .overlay {
                    HStack {
                        Text(bc.title)
                            .foregroundStyle(.white)
                            .padding(.leading)
                        Spacer()
                        Text("★")
                            .foregroundStyle(Color(uiColor: SomeColors.gold))
                            .padding(.trailing)
                    }
                }
                .padding(.horizontal)
                .onTapGesture {
                    path.append("detail")
                }
                .navigationDestination(for: String.self) { val in
                    ContentView(path: $path, titleText: bc.title)
                }
        }
    }
    
    fileprivate func addButton() -> some View {
        return VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray)
                .background(Color.clear)
                .frame(height: 80)
                .overlay {
                    Text("✚")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                }
                .onTapGesture {
                    withAnimation {
                        showDetail = true
                        disableScroll = true
                    }
                    
                }
                .shadow(radius: 10)
                .padding(.horizontal, 20)
        }
        .matchedGeometryEffect(id: "AddBreadCrumb", in: namespace)
    }
    
    fileprivate func listOfBreadcrumbs() -> VStack<some View> {
        return VStack {
            ScrollView {
                ForEach(listOfBC) { bc in
                    breadcrumbCell(bc)
                }
                .padding(.bottom, 120)
            }
            .disabled(disableScroll)
            .blur(radius: showDetail ? 2 : 0)
            .overlay {
                if showDetail {
                    Color.black.opacity(0.18)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    fileprivate func createBredcrumb() -> some View {
        
        return VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray)
                .overlay {
                    VStack {
                        Text("Breadcrumb")
                            .foregroundStyle(.white)
                        TextField("some", text: $text)
                            .textFieldStyle(.roundedBorder)
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
                            Spacer()
                            Button("Cancel") {
                                withAnimation {
                                    text = ""
                                    showDetail = false
                                    disableScroll = false
                                }
                            }
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
        .matchedGeometryEffect(id: "AddBreadCrumb", in: namespace)
        .padding(.horizontal, 45)
        .zIndex(1)
    }
    
    
}

#Preview {
    BreadcrumsList()
}
