//
//  BreadCrumbCreationAlert.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//
import SwiftUI
import Neuromorphic

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
                            .cornerRadius(20)

                            .neumorph(state: .base(state: .off))
                            .padding()
                        
                        HStack {
                            Text("⏱️")
                            .frame(width: 80, height: 40)
                            .neumorph(didPress: $viewModel.isRepCounter,
                                      state: .animated(tappable: {
                                viewModel.isRepCounter = false
                            }))
                            
                            Text("🔁")
                            .frame(width: 80, height: 40)
                            .neumorph(didPress: $viewModel.isRepCounter.inverted,
                                      state: .animated(tappable: {
                                viewModel.isRepCounter = true
                            }))

                        }
                        
                        HStack {
                            Text("OK")
                                .monospaced()
                                .tint(.black)
                                .padding()
                                .neumorph(state: .base(state: .on, tappable: {
                                    if !viewModel.textfieldText.isEmpty {
                                        let bc = BreadCrumbState(breadcrumb: BreadCrumb(title: viewModel.textfieldText), isTimer: viewModel.isRepCounter)
                                        viewModel.listOfBC.append(bc)
                                        BreadcrumsSaver.shared.saveToList(bc)
                                    }
                                    
                                    withAnimation {
                                        viewModel.textfieldText = ""
                                        viewModel.showAddBreadcrumbAlert(false)
                                    }
                                }))
//                            .neuro()
                            
                            
                            Spacer()
                            
                            Text("Cancel")
                            .monospaced()
                            .foregroundStyle(.red)
                            .padding()
                            .neumorph(state: .base(state: .on, tappable: {
                                withAnimation {
                                    viewModel.textfieldText = ""
                                    viewModel.showAddBreadcrumbAlert(false)
                                }
                            }))
                        }
                        .padding()
                    }
                }
//                .onTapGesture {
//                    withAnimation {
//                        viewModel.textfieldText = ""
//                        viewModel.showAddBreadcrumbAlert(false)
//                    }
//                    
//                }
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
