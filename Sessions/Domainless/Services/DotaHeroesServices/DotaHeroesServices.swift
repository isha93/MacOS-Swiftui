//
//  DotaHeroesServices.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import Foundation

protocol DotaHeroesServicesProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    func getPokemon(endPoint: NetworkFactory) async throws -> [DotaHeroesModelData]
}

class DotaHeroesServices: DotaHeroesServicesProtocol {
    var networker: NetworkerProtocol
    
    init(networker: NetworkerProtocol) {
        self.networker = networker
    }
    
    func getPokemon(endPoint: NetworkFactory) async throws -> [DotaHeroesModelData] {
        return try await networker.taskAsync(type: [DotaHeroesModelData].self, endPoint: endPoint, isMultipart: false)
    }
}
