//
//  CategoriesView.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel = CategoriesViewModel()
    @State private var selectionCategories: String = "Categories"
    @State private var selectionHeroes: DotaHeroesModelData = .init(id: 1, name: "", localizedName: "", primaryAttr: .agi, attackType: .melee, roles: [], legs: 1)
    @State private var clickedCategories: Bool = false
    @State private var clickedHeroes: Bool = false
    @State private var heroes: String = ""
    @State private var selectedIndexCategoreies: Int = 0
    @State private var textLenght: Int = 0
    @State private var switchedToCategories: Bool = false
    var body: some View {
        ScrollView {
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.green)
                Text(selectionCategories)
                Spacer()
                Image(systemName: clickedCategories ? "arrowtriangle.up" : "arrowtriangle.down")
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .onTapGesture {
                withAnimation(.bouncy) {
                    clickedCategories.toggle()
                    clickedHeroes = false
                }
            }
            
            if clickedCategories {
                CategoriesListView(
                    clickedCategories: $clickedCategories,
                    selectionCategories: $selectionCategories,
                    clickedHeroes: $clickedHeroes
                )
                .environmentObject(viewModel)
            }
            
            TextField("What's your heroes", text: $heroes, onEditingChanged: { focused in
                clickedHeroes = focused
            })
            .onChange(of: heroes, { oldValue, newValue in
                if newValue.count < textLenght {
                    withAnimation {
                        clickedHeroes = true
                        viewModel.openCategories = false
                        switchedToCategories = false
                    }
                }
                textLenght = newValue.count
                viewModel.searchText = newValue
            })
            .textFieldStyle(.plain)
            .padding()
            .background(.white)
            .cornerRadius(10)
            .focusable()
            
            if clickedHeroes {
                HeroesListView(
                    clickedCategories: $clickedCategories,
                    selectionHeroes: $selectionHeroes,
                    selectionNameHeroes: $heroes,
                    clickedHeroes: $clickedHeroes,
                    selectionCategories: $selectionCategories
                )
                .environmentObject(viewModel)
            }
            
            if switchedToCategories {
                CategoriesListView(
                    clickedCategories: $clickedCategories,
                    selectionCategories: $selectionCategories,
                    clickedHeroes: $clickedHeroes
                )
                .environmentObject(viewModel)
            }
            
            ChoosenListView()
                .padding(.vertical)
                .environmentObject(viewModel)
        }
        .onChange(of: viewModel.openCategories) { _, newValue in
            if newValue {
                withAnimation {
                    clickedHeroes = false
                    switchedToCategories = true
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
}

