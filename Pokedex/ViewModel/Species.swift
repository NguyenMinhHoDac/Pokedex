//
//  Species.swift
//  Pokedex
//
//  Created by SMin on 10/08/2022.
//

import Foundation

struct Species : Decodable
{
    let name: String
    let url: String
  
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
  }
}

struct SpeciesProp : Decodable
{
    let eggGroups: [EggGroups]
    let hatch: Int
    let textEntries: [FlavorText2]
    let habitat: Habitat
    let generation: Generation
    let captureRate: Int
    let evolutionChain: EvolutionChain
    let varieties: [Varietie]
  
    enum CodingKeys: String, CodingKey {
        case eggGroups = "egg_groups"
        case hatch = "hatch_counter"
        case textEntries = "flavor_text_entries"
        case habitat = "habitat"
        case generation = "generation"
        case captureRate = "capture_rate"
        case evolutionChain = "evolution_chain"
        case varieties = "varieties"
  }
}

struct EggGroups : Decodable
{
    let name: String
  
    enum CodingKeys: String, CodingKey {
        case name = "name"
  }
}

struct Habitat : Decodable
{
    let name: String
  
    enum CodingKeys: String, CodingKey {
        case name = "name"
  }
}

struct Generation : Decodable
{
    let name: String
  
    enum CodingKeys: String, CodingKey {
        case name = "name"
  }
}

struct EvolutionChain : Decodable
{
    let url: String
  
    enum CodingKeys: String, CodingKey {
        case url = "url"
  }
}

struct Varietie : Decodable
{
    let pokemon: PrePokemon
  
    enum CodingKeys: String, CodingKey {
        case pokemon = "pokemon"
  }
}
