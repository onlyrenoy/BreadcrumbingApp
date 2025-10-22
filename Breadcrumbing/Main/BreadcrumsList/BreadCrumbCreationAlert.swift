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
                            Button("OK") {
                                if !viewModel.textfieldText.isEmpty {
                                    viewModel.listOfBC.append(BreadCrumb(title: viewModel.textfieldText))
                                    BreadcrumsSaver.shared.saveToList(BreadCrumb(title: viewModel.textfieldText))
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
        .frame(height: 240)
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
