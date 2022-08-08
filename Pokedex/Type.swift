//
//  Type.swift
//  Pokedex
//
//  Created by SMin on 02/08/2022.
//

import Foundation

struct PokeType : Decodable
{
    let name: String
    let url: String
  
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
  }
}

struct ListType : Decodable
{
    let slot: Int
    let pokeType : PokeType
  
    enum CodingKeys: String, CodingKey {
        case slot = "slot"
        case pokeType = "type"
  }
}

struct DamageRelations : Decodable
{
    let all: DamageRelation
    
    enum CodingKeys: String, CodingKey {
        case all = "damage_relations"
    }
}

struct DamageRelation : Decodable
{
    let doubleDamageFrom: [PokeType]
    let halfDamageFrom: [PokeType]
    let noDamegeFrom: [PokeType]
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case halfDamageFrom = "half_damage_from"
        case noDamegeFrom = "no_damage_from"
    }
}

var type = [
            0 : "bug",
            1 :  "dark",
            2 : "dragon",
            3 : "electric",
            4 : "fairy",
            5 : "fighting",
            6 : "fire",
            7 : "flying",
            8 : "ghost",
            9 : "grass",
            10 : "ground",
            11 : "ice",
            12 : "normal",
            13 : "poison",
            14 : "psychic",
            15 : "rock",
            16 : "steel",
            17 : "water"
           ]
