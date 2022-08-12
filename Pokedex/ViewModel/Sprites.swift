//
//  Sprites.swift
//  Pokedex
//
//  Created by SMin on 02/08/2022.
//

import Foundation

struct Sprites : Decodable
{
    let other: Other
  
    enum CodingKeys: String, CodingKey {
        case other = "other"
  }
}

struct Other : Decodable
{
    let home: Home
    let official: Official
  
    enum CodingKeys: String, CodingKey {
        case home = "home"
        case official = "official-artwork"
  }
}

struct Home : Decodable
{
    let imgDefault: String
    let imgShiny: String
    
    enum CodingKeys: String, CodingKey {
        case imgDefault = "front_default"
        case imgShiny = "front_shiny"
  }
}

struct Official : Decodable
{
    let img: String
    
    enum CodingKeys: String, CodingKey {
        case img = "front_default"
  }
}
