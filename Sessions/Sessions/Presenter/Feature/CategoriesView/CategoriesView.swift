//
//  CategoriesView.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import SwiftUI

struct CategoriesView: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @StateObject var viewModel = CategoriesViewModel()
    @State private var selectionCategories: String = "Categories"
    @State private var selectionHeroes: DotaHeroesModelData = .init(id: 1, name: "", localizedName: "", primaryAttr: .agi, attackType: .melee, roles: [], legs: 1)
    @State private var clickedCategories: Bool = false
    @State private var clickedHeroes: Bool = false
    @State private var heroes: String = ""
    @State private var selectedIndexCategoreies: Int = 0
    @State private var textLenght: Int = 0
    @State private var switchedToCategories: Bool = false
    @FocusState private var focusedField: FocusedField?
    var body: some View {
        ZStack {
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
                        switchedToCategories = false
                        clickedHeroes = false
                        viewModel.handleCategoresState()
                    }
                }
                
                if clickedCategories {
                    CategoriesListView(
                        clickedCategories: $clickedCategories,
                        selectionCategories: $selectionCategories,
                        clickedHeroes: $clickedHeroes,
                        categoryFocus: $focusedField
                    )
                    .focused($focusedField, equals: .categoriesName)
                    .environmentObject(viewModel)
                }
                
                TextField("What's your heroes", text: $heroes)
                .focusable()
                .onKeyPress(.upArrow, action: {
                    clickedCategories = true
                    clickedHeroes = false
                    focusedField = .categoriesName
                    return .handled
                })
                .onKeyPress(.downArrow, action: {
                    focusedField = .heroesName
                    return .handled
                })
                .onKeyPress(.return) {
                    withAnimation {
                        clickedHeroes = false
                        clickedCategories = false
                        selectionCategories = "Categories"
                        DispatchQueue.main.async {
                            viewModel.selectedHeroesbyName(with: heroes)
                        }
                    }
                    return .handled
                }
                .onKeyPress(.delete) {
                    let primaryAttr: PrimaryAttr = PrimaryAttr(rawValue: self.selectionCategories) ?? .all
                    viewModel.handlerCategoriesHeroes(with: primaryAttr)
                    return .handled
                }
                .focused($focusedField, equals: .inputField)
                .onChange(of: heroes, { oldValue, newValue in
                    if newValue.count < textLenght && !newValue.isEmpty {
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
                
                ChoosenListView()
                    .padding(.vertical)
                    .environmentObject(viewModel)
                    .overlay(alignment: .top) {
                        Group {
                            if clickedHeroes {
                                HeroesListView(
                                    clickedCategories: $clickedCategories,
                                    selectionHeroes: $selectionHeroes,
                                    selectionNameHeroes: $heroes,
                                    clickedHeroes: $clickedHeroes,
                                    selectionCategories: $selectionCategories, 
                                    heroesFocus: $focusedField
                                )
                                .environmentObject(viewModel)
                            }
                            
                            if switchedToCategories {
                                CategoriesListView(
                                    clickedCategories: $clickedCategories,
                                    selectionCategories: $selectionCategories,
                                    clickedHeroes: $clickedHeroes,
                                    categoryFocus: $focusedField
                                )
                                .environmentObject(viewModel)
                            }
                        }
                    }
            }
        }
        .onAppear {
            focusedField = .categoriesName
        }
        .onChange(of: viewModel.openCategories) { _, newValue in
            if newValue {
                withAnimation {
                    clickedHeroes = false
                    switchedToCategories = true
                }
            }
        }
        .onChange(of: clickedHeroes) { _, newValue in
            if newValue {
                withAnimation {
                    clickedCategories = false
                    switchedToCategories = false
                    heroes = ""
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
}

enum FocusedField {
    case categoriesName
    case inputField
    case heroesName
}
