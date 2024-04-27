//
//  ChoosenListView.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import SwiftUI

struct ChoosenListView: View {
    @EnvironmentObject var viewModel: CategoriesViewModel
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var selectedIndexCategories: Int? = 0
    @FocusState.Binding var choosenFocus: FocusedField?
    var body: some View {
        LazyVStack {
            ForEach(Array(viewModel.choosenListView.enumerated()), id: \.element) { index, item in
                HStack {
                    Image(systemName: "square")
                        .frame(width: 10, height: 10)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(item.heroes)
                            .font(.title)
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.green)
                            Text(item.categories)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .onTapGesture {
                    selectedIndexCategories = index
                }
                .padding()
                .background(index == selectedIndexCategories ? Color.blue.opacity(0.3) : Color.clear)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .focusable()
            .focused($choosenFocus, equals: .choosenHeroes)
            .onMoveCommand { direction in
                selectedCategories(direction, layoutDirection: layoutDirection)
            }
            .onAppear {
                selectedIndexCategories = 0
            }
        }
    }
    
    private func selectedCategories(_ direction: MoveCommandDirection, layoutDirection: LayoutDirection) {
        guard let currentIndex = selectedIndexCategories else { return }
        
        switch direction {
        case .up:
            if currentIndex > 0 {
                selectedIndexCategories = currentIndex - 1
            } else {
                choosenFocus = .inputField
            }
        case .down:
            if currentIndex < viewModel.choosenListView.count - 1 {
                selectedIndexCategories = currentIndex + 1
            }
        default:
            break
        }
    }
}
