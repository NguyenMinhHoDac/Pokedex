//
//  Abilities.swift
//  Pokedex
//
//  Created by SMin on 08/08/2022.
//

struct ListAbility : Decodable
{
    let ability: Ability
    let isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case ability = "ability"
        case isHidden = "is_hidden"
    }
}

struct Ability : Decodable
{
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}


