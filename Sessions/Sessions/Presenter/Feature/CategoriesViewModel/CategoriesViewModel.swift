//
//  CategoriesViewModel.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import Foundation
import Combine

@MainActor
class CategoriesViewModel: ObservableObject {
    @Published var categories: [DotaHeroesModelData] = []
    @Published var selectedHeroesCategories: [DotaHeroesModelData] = []
    @Published var searchHeroesCategories: [DotaHeroesModelData] = []
    @Published var categoriesState: [String: String] = [:]
    @Published var selectedCategories = "Categories"
    @Published var selectedCategoriesKey: PrimaryAttr = .all
    @Published var errorMessage: String = ""
    @Published var searchText = ""
    @Published var openCategories: Bool = false
    @Published var choosenListView: [ChoosenModelData] = []
    
    @Published var filteredCategories: [String : String] = [:]
    
    private var subscriptions = Set<AnyCancellable>()
    private let service: DotaHeroesServicesProtocol
    
    init(service: DotaHeroesServicesProtocol = DotaHeroesServices(networker: Networker())) {
        self.service = service
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
            if t.contains("@") {
                    self?.openCategories = true
                    self?.filterCategories(with: t)
                }
                self?.searchCategoriesHeroes(with: t)
            } )
            .store(in: &subscriptions)
        Task {
            await getHeroes()
        }
    }
    
    func handleCategoresState() {
        let data = [
            "All": "all",
            "Strength": "str",
            "Agility": "agi",
            "Intelligence": "int"
        ]
        self.categoriesState = data
        self.filteredCategories = data
    }
    
    func getHeroes() async {
        do {
            let heroes = try await service.getPokemon(endPoint: .getHeroes)
            self.categories = heroes
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func handlerCategoriesHeroes(with categories: PrimaryAttr) {
        selectedCategoriesKey = categories
        switch categories {
        case .agi:
            self.selectedHeroesCategories = self.categories.filter({ $0.primaryAttr == .agi })
        case .all:
            self.selectedHeroesCategories = self.categories.filter({ $0.primaryAttr == .all })
        case .int:
            self.selectedHeroesCategories = self.categories.filter({ $0.primaryAttr == .int })
        case .str:
            self.selectedHeroesCategories = self.categories.filter({ $0.primaryAttr == .str })
        }
    }
    
    func searchCategoriesHeroes(with keyWord: String) {
        if !keyWord.isEmpty {
            self.searchHeroesCategories = self.selectedHeroesCategories.filter { $0.localizedName.range(of: keyWord, options: .caseInsensitive) != nil }
        } else {
            self.handlerCategoriesHeroes(with: selectedCategoriesKey)
        }
    }
    
    func selectedHeroesbyName(with name: String) {
        let hero = ChoosenModelData(categories: selectedCategories, heroes: name, id: .random(in: 1...100))
        self.choosenListView.append(hero)
    }
    
    func handlerChoosenData(heroes: DotaHeroesModelData) {
        let item : ChoosenModelData = ChoosenModelData(categories: selectedCategories, heroes: heroes.localizedName, id: heroes.id)
        self.choosenListView.append(item)
    }
    
    func filterCategories(with keyWord: String) {
        guard keyWord.count > 1 else {
            filteredCategories = categoriesState
            return
        }
        
        let finalsKey = keyWord.split(separator: "@")
        let modifiedKey = finalsKey.count > 1 ? String(finalsKey.last!).trimmingCharacters(in: .whitespacesAndNewlines) : ""
        
        if !modifiedKey.isEmpty {
            let filter = categoriesState.filter { key, _ in
                key.range(of: modifiedKey, options: .caseInsensitive) != nil
            }
            filteredCategories = filter
        } else {
            filteredCategories = categoriesState
        }
    }
}
