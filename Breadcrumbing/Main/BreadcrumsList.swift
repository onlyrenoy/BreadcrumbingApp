//
//  BreadcrumsList.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 16/10/25.
//

import SwiftUI

struct BreadcrumsList: View {
    @Namespace var namespace
    
    @StateObject var viewModel = BreadcrumsListViewModel()
    
    @EnvironmentObject var route: Router
    
    var body: some View {
        ZStack {
            Color.neuBackground
                .ignoresSafeArea()
            listOfBreadcrumbs()
            
            addButton()
            
            if viewModel.showDetail {
                createBredcrumb()
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
                .neuro(autoReset: true)
                .background { Color.clear }
                .padding(.horizontal)
        }
        
    }
    
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
                .neuro(autoReset: true)
                .background { Color.clear }
                .onTapGesture {
                    withAnimation {
                        viewModel.showDetail = true
                        viewModel.disableScroll = true
                    }
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
        }
        .matchedGeometryEffect(id: "AddBreadCrumb", in: namespace)
    }
    
    fileprivate func listOfBreadcrumbs() -> some View {
        return VStack {
            ScrollView {
                ForEach(viewModel.listOfBC, id: \.id) { bc in
                    breadcrumbCell(bc)
                        .onTapGesture {
                            route.push(.detail(title: bc.title))
                        }
                }
                .padding(.bottom, 120)
            }
            .disabled(viewModel.disableScroll)
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
                        TextField("some", text: $viewModel.textfieldText)
                            .padding()
                            .border(.background)
                            .cornerRadius(20)
                            .neuro(concave: .constant(false))
                            .padding()
                        
                        HStack {
                            Button("OK") {
                                if !viewModel.textfieldText.isEmpty {
                                    viewModel.listOfBC.append(BreadCrumb(title: viewModel.textfieldText))
                                }
                                
                                withAnimation {
                                    viewModel.textfieldText = ""
                                    viewModel.showDetail = false
                                    viewModel.disableScroll = false
                                    
                                }
                            }
                            .padding()
                            .neuro()
                            
                            
                            Spacer()
                            Button("Cancel") {
                                withAnimation {
                                    viewModel.textfieldText = ""
                                    viewModel.showDetail = false
                                    viewModel.disableScroll = false
                                }
                            }
                            .padding()
                            .neuro()
                        }
                        .padding()
                    }
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.textfieldText = ""
                        viewModel.showDetail = false
                        viewModel.disableScroll = false
                    }
                    
                }
        }
        .frame(height: 240)
        .neuro()
        .matchedGeometryEffect(id: "AddBreadCrumb", in: namespace)
        .padding(.horizontal, 45)
        .zIndex(1)
    }
    
    
}

#Preview {
    BreadcrumsList()
}
