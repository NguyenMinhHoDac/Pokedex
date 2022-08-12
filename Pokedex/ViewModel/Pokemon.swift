//
//  Pokemon.swift
//  Pokedex
//
//  Created by SMin on 02/08/2022.
//

import Foundation

struct PrePokemon : Decodable {
    //let id: Int
    let name: String
  //let img: String
  //let types: [String]
    let url: String
  
    enum CodingKeys: String, CodingKey {
        //case id
        case name = "name"
        //case img
        //case types
        case url = "url"
  }
}

struct PrePokemons : Decodable {
  let count: Int
  let all: [PrePokemon]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}

struct Pokemon : Decodable {
    let id: Int
    let name: String
    let species: Species
    let sprites: Sprites
    let types: [ListType]
    let stats: [ListStat]
    let abilities: [ListAbility]
    let moves: [ListMove]
  
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case species = "species"
        case sprites = "sprites"
        case types = "types"
        case stats = "stats"
        case abilities = "abilities"
        case moves = "moves"
  }
}



