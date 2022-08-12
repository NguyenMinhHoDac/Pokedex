//
//  Evolution.swift
//  Pokedex
//
//  Created by SMin on 11/08/2022.
//

import Foundation

struct Chain : Decodable
{
    let chain: Evolution
  
    enum CodingKeys: String, CodingKey {
        case chain = "chain"
  }
}

struct Evolution : Decodable
{
    let evolutionDetails: [EvolutionDetails]
    let evolvesTo: [Evolution]
    let species: Species
  
    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
        case species = "species"
  }
}

struct EvolutionDetails : Decodable
{
    let level: Int?
    let item: Item?
    let happiness: Int?
  
    enum CodingKeys: String, CodingKey {
        case level = "min_level"
        case item = "item"
        case happiness = "min_happiness"
  }
}

struct Item : Decodable
{
    let name: String
  
    enum CodingKeys: String, CodingKey {
        case name = "name"
  }
}
