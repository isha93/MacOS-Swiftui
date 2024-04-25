//
//  HoresListView.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import SwiftUI

struct HeroesListView: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @EnvironmentObject var viewModel: CategoriesViewModel
    @Binding var clickedCategories: Bool
    @Binding var selectionHeroes: DotaHeroesModelData
    @Binding var selectionNameHeroes: String
    @Binding var clickedHeroes: Bool
    @Binding var selectionCategories: String
    @State private var selectedIndexHeroes: Int? = nil
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(Array(viewModel.selectedHeroesCategories.enumerated()), id: \.element) { index, item in
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                    Text(item.localizedName)
                    Spacer()
                }
                .focusable()
                .onTapGesture {
                    selectedIndexHeroes = index
                }
                .onKeyPress(.return) {
                    withAnimation(.bouncy) {
                        clickedHeroes = false
                        clickedCategories = false
                        selectionNameHeroes = ""
                        selectionCategories = "Categories"
                        if let selectedIndex = selectedIndexHeroes {
                            selectionHeroes = viewModel.selectedHeroesCategories[selectedIndex]
                            DispatchQueue.main.async {
                                viewModel.handlerChoosenData(
                                    heroes: viewModel.selectedHeroesCategories[selectedIndex]
                                )
                            }
                        }
                    }
                    return .handled
                }
                .padding()
                .background(index == selectedIndexHeroes ? Color.blue.opacity(0.3) : Color.clear)
            }
        }
        .focusable()
        .onMoveCommand(perform: { direction in
            selectedHeroes(direction, layoutDirection: layoutDirection)
        })
        .background(.white)
        .cornerRadius(10)
    }
    
    private func selectedHeroes(_ direction: MoveCommandDirection, layoutDirection: LayoutDirection) {
        guard let currentIndex = selectedIndexHeroes else { return }

        switch direction {
        case .up:
            if currentIndex > 0 {
                selectedIndexHeroes = currentIndex - 1
            }
        case .down:
            if currentIndex < viewModel.selectedHeroesCategories.count - 1 {
                selectedIndexHeroes = currentIndex + 1
            }
        default:
            break
        }
    }
}
