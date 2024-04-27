//
//  CategoryListView.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import SwiftUI
struct CategoriesListView: View {
    @EnvironmentObject var viewModel: CategoriesViewModel
    @Environment(\.layoutDirection) private var layoutDirection
    @Binding var clickedCategories: Bool
    @Binding var selectionCategories: String
    @Binding var clickedHeroes: Bool
    @State var selectedIndexCategories: Int? = nil
    @FocusState private var categoryFocus: Bool

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(Array(viewModel.filteredCategories.keys.enumerated()), id: \.element) { index, key in
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.green)
                        Text(key)
                        Spacer()
                    }
                    .focusable()
                    .onTapGesture(count: 2) {
                        withAnimation(.bouncy) {
                            handleCategorySelection()
                        }
                    }
                    .onKeyPress(.return) {
                        withAnimation(.bouncy) {
                            handleCategorySelection()
                        }
                        return .handled
                    }
                    .padding()
                    .background(index == selectedIndexCategories ? Color.blue.opacity(0.3) : Color.clear)
                    .onAppear {
                        selectedIndexCategories = 0
                    }
                }
             
            }
            .onMoveCommand(perform: { direction in
                selectedCategories(direction, layoutDirection: layoutDirection)
            })
            .background(Color.white)
            .cornerRadius(10)
            .focused($categoryFocus)
            .onAppear {
                categoryFocus = true
            }
        }
    }
    
    func handleCategorySelection() {
        withAnimation(.bouncy) {
            clickedCategories = false
            if let selectedIndex = selectedIndexCategories,
               let selectedKey = Array(viewModel.filteredCategories.keys).dropFirst(selectedIndex).first {
                selectionCategories = selectedKey
                viewModel.selectedCategories = selectedKey
                DispatchQueue.main.async {
                    handlerSubmitCategories(key: viewModel.filteredCategories[selectedKey] ?? "")
                }
                clickedHeroes = true
            }
        }
    }

    private func selectedCategories(_ direction: MoveCommandDirection, layoutDirection: LayoutDirection) {
        guard let currentIndex = selectedIndexCategories else { return }

        switch direction {
        case .up:
            if currentIndex > 0 {
                selectedIndexCategories = currentIndex - 1
            }
        case .down:
            if currentIndex < viewModel.filteredCategories.count - 1 {
                selectedIndexCategories = currentIndex + 1
            }
        default:
            break
        }
    }
    
    private func handlerSubmitCategories(key: String) {
        let primaryAttr: PrimaryAttr = PrimaryAttr(rawValue: key) ?? .all
        viewModel.handlerCategoriesHeroes(with: primaryAttr)
    }
}
