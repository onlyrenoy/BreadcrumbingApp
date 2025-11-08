//
//  RepCounterView.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 08/11/25.
//
import SwiftUI
import Neuromorphic
import SPConfetti

struct RepCounterView: View {
    @State var breadcrumb: BreadCrumb
    @EnvironmentObject var viewModel: BreadcrumbingViewModel
    
    var body: some View {
        VStack {
            Text(breadcrumb.title.uppercased())
                .boldMonospaced()
                Spacer()
            
            Text("\(viewModel.totalCount)/50") //counter
                .boldMonospaced()
                Spacer()
            
            //serve un bool per aggiornamento item
            Grid(horizontalSpacing: 30, verticalSpacing: 15) {
                ForEach(viewModel.reps.indices, id: \.self) { mainIndex in
                    GridRow {
                        ForEach(0..<5) { columnIndex in
                            let index = mainIndex * 5 + columnIndex
                            if index < viewModel.reps.count {
                                Rectangle()
                                    .fill(viewModel.reps[index].isSelected ? .green : Color.neuBackground)
                                    .frame(width: 40, height: 40)
                                    .neumorph(state: .base(state: viewModel.reps[index].isSelected ? .on : .off), cornerRadius: 54)
                            }
                        }
                    }
                }
            }
            
            HStack {
                Text("+")
                    .padding()
                    .onTapGesture {
                        viewModel.repCounterUpdate()
                    }
            }
            .frame(height: 54)
            .frame(maxWidth: 54)
            .neuro(concave: .constant(true), cornerRadius: 54)
            .padding(.top, 30)
            .confetti(isPresented: $viewModel.showConfetti,
                      animation: .fullWidthToDown,
                      particles: [.arc, .heart, .star],
                      duration: 3)
            .confettiParticle(\.velocity, 300)
        }
    }
}
