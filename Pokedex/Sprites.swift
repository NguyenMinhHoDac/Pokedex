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
    let official: Official
  
    enum CodingKeys: String, CodingKey {
        case official = "official-artwork"
  }
}

struct Official : Decodable
{
    let img: String
    
    enum CodingKeys: String, CodingKey {
        case img = "front_default"
  }
}

//struct Sprites : Decodable
//{
//    let img: String
//
//    enum CodingKeys: String, CodingKey {
//        case img = "front_default"
//  }
//}
