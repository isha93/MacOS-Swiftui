//
//  HeroesDotaModel.swift
//  Sessions
//
//  Created by NurFajar, Isa | INPD on 2024/04/25.
//

import Foundation

struct DotaHeroesModelData: Codable, Hashable {
    let id: Int
    let name, localizedName: String
    let primaryAttr: PrimaryAttr
    let attackType: AttackType
    let roles: [Role]
    let legs: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles, legs
    }
}

enum AttackType: String, Codable {
    case melee = "Melee"
    case ranged = "Ranged"
}

enum PrimaryAttr: String, Codable {
    case agi = "agi"
    case all = "all"
    case int = "int"
    case str = "str"
}

enum Role: String, Codable {
    case carry = "Carry"
    case disabler = "Disabler"
    case durable = "Durable"
    case escape = "Escape"
    case initiator = "Initiator"
    case nuker = "Nuker"
    case pusher = "Pusher"
    case support = "Support"
}
