//
//  BreadCrumbCreationAlert.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//
import SwiftUI

struct BreadCrumbCreationAlert: View {
    var ns: Namespace.ID
    @ObservedObject var viewModel: BreadcrumsListViewModel
    
    @State var didpress = false
    
    
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .overlay {
                    VStack {
                        Text("Breadcrumb".uppercased())
                            .monospaced()
                            .foregroundStyle(.black)
                        TextField("Add Breadcrumb", text: $viewModel.textfieldText)
                            .monospaced()
                            .padding()
                            .border(.background)
                            .cornerRadius(20)
                            .neuro(concave: .constant(false))
                            .padding()
                        
                        HStack {
                            Button {
                                viewModel.isRepCounter = false
                            } label: {
                                Text("⏱️")
                                    
                            }
                            .frame(width: 80, height: 40)
                            .neuro(concave: $viewModel.isRepCounter)
                            
                            Button {
                                viewModel.isRepCounter = true
                            } label: {
                                Text("🔁")
                            }
                            .frame(width: 80, height: 40)
                            .neuro(concave: $viewModel.isRepCounter.inverted)

                        }
                        
                        HStack {
                            Button("OK") {
                                if !viewModel.textfieldText.isEmpty {
                                    let bc = BreadCrumbState(breadcrumb: BreadCrumb(title: viewModel.textfieldText), isTimer: viewModel.isRepCounter)
                                    viewModel.listOfBC.append(bc)
                                    BreadcrumsSaver.shared.saveToList(bc)
                                }
                                
                                withAnimation {
                                    viewModel.textfieldText = ""
                                    viewModel.showAddBreadcrumbAlert(false)
                                    
                                }
                            }
                            .monospaced()
                            .tint(.black)
                            .padding()
                            .neuro()
                            
                            
                            Spacer()
                            Button("Cancel") {
                                withAnimation {
                                    viewModel.textfieldText = ""
                                    viewModel.showAddBreadcrumbAlert(false)
                                }
                            }
                            .monospaced()
                            .tint(.red)
                            .padding()
                            .neuro()
                        }
                        .padding()
                    }
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.textfieldText = ""
                        viewModel.showAddBreadcrumbAlert(false)
                    }
                    
                }
        }
        .frame(height: 300)
        .neuro()
        .matchedGeometryEffect(id: "AddBreadCrumb", in: ns)
        .padding(.horizontal, 45)
        .zIndex(1)
    }
}

#Preview {
    @Previewable @Namespace var ns
    BreadCrumbCreationAlert(ns: ns,
                            viewModel: BreadcrumsListViewModel())
}
