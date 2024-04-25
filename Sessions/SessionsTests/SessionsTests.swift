//
//  SessionsTests.swift
//  SessionsTests
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import XCTest
@testable import Sessions

@MainActor
final class SessionsTests: XCTestCase {
    private var sut: CategoriesViewModel?
    
    override func setUpWithError() throws {
        super.setUp()
        sut = nil
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        super.tearDown()
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_handleCategoresState() {
        let mockCategoriesState = [
            "All": "all",
            "Strength": "str",
            "Agility": "agi",
            "Intelligence": "int"
        ]
        sut = CategoriesViewModel()
        XCTAssertEqual(mockCategoriesState, sut?.categoriesState)
    }
    
    func testHandlerCategoriesHeroes_agi() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        
        Task {
            do {
                await sut.getHeroes()
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        sut.handlerCategoriesHeroes(with: .agi)
        
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
        XCTAssertEqual(sut.selectedHeroesCategories[0].primaryAttr, .agi)
    }
    
    func testHandlerCategoriesHeroes_int() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        
        Task {
            do {
                await sut.getHeroes()
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        sut.handlerCategoriesHeroes(with: .int)
        
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
        XCTAssertEqual(sut.selectedHeroesCategories[0].primaryAttr, .int)
    }
    
    func testHandlerCategoriesHeroes_str() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        
        Task {
            do {
                await sut.getHeroes()
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        sut.handlerCategoriesHeroes(with: .str)
        
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
        XCTAssertEqual(sut.selectedHeroesCategories[0].primaryAttr, .str)
    }
    
    func testHandlerCategoriesHeroes_all() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        
        Task {
            do {
                await sut.getHeroes()
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        sut.handlerCategoriesHeroes(with: .all)
        
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
        XCTAssertEqual(sut.selectedHeroesCategories[0].primaryAttr, .all)
    }
    
    func testHandlerCategoriesHeroes() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        
        Task {
            do {
                await sut.getHeroes()
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        sut.handlerCategoriesHeroes(with: .agi)
        
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
        XCTAssertEqual(sut.selectedHeroesCategories[0].primaryAttr, .agi)
    }
    
    func testHandlerCategoriesHeroes_failed() {
        let mockService = MockServices(isSuccess: false)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        Task {
            do {
                await sut.getHeroes()
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        sut.handlerCategoriesHeroes(with: .agi)
        XCTAssertEqual(sut.selectedHeroesCategories.count, 0)
    }
    
    func testHandlerSearchHeroes_success() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        Task {
            do {
                await sut.getHeroes()
                sut.selectedHeroesCategories = sut.categories
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        sut.searchCategoriesHeroes(with: "Pudge")
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
    }
    
    func testHandlerSearchHeroes_success_empty() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let getHeroesExpectation = expectation(description: "Fetch heroes")
        Task {
            do {
                await sut.getHeroes()
                sut.selectedHeroesCategories = sut.categories
                getHeroesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        sut.searchCategoriesHeroes(with: "")
        XCTAssertEqual(sut.selectedHeroesCategories.count, 1)
    }
    
    func test_handlerChoosenData() {
        let mockService = MockServices(isSuccess: true)
        let sut = CategoriesViewModel(service: mockService)
        let mockData = DotaHeroesModelData(id: 123, name: "Morted", localizedName: "Morted", primaryAttr: .agi, attackType: .melee, roles: [.carry], legs: 2)
        sut.handlerChoosenData(heroes: mockData)
        XCTAssertEqual(mockData.localizedName, sut.choosenListView.first?.heroes)
    }

}

extension SessionsTests {
    class MockServices: DotaHeroesServicesProtocol {
        var networker: Sessions.NetworkerProtocol
        var isSuccess: Bool
        init(networker: Sessions.NetworkerProtocol = Networker(), isSuccess: Bool) {
            self.networker = networker
            self.isSuccess = isSuccess
        }
        
        func getPokemon(endPoint: Sessions.NetworkFactory) async throws -> [Sessions.DotaHeroesModelData] {
            if isSuccess {
                let mockDataAgi = DotaHeroesModelData(id: 12, name: "Magina", localizedName: "Magina", primaryAttr: .agi, attackType: .melee, roles: [], legs: 2)
                let mockDataStr = DotaHeroesModelData(id: 12, name: "Pudge", localizedName: "Pudge", primaryAttr: .str, attackType: .melee, roles: [], legs: 2)
                let mockDataInt = DotaHeroesModelData(id: 12, name: "Silencer", localizedName: "Silencer", primaryAttr: .int, attackType: .ranged, roles: [], legs: 2)
                let mockDataAll = DotaHeroesModelData(id: 12, name: "Bane", localizedName: "Bane", primaryAttr: .all, attackType: .ranged, roles: [], legs: 2)
                
                let mockData = [mockDataAgi, mockDataStr, mockDataInt, mockDataAll]
                return mockData
            } else {
                throw NetworkError.decodingError(message: "")
            }
        }
    }
}
