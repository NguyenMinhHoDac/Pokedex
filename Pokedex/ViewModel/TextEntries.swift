//
//  TextEntries.swift
//  Pokedex
//
//  Created by SMin on 10/08/2022.
//

import Foundation

struct TextEntries : Decodable
{
  let all: [FlavorText]
  
  enum CodingKeys: String, CodingKey {
    case all = "flavor_text_entries"
  }
}

struct FlavorText : Decodable
{
    let flavorText: String
    let language: Language
    let version: VersionGroup
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language = "language"
        case version = "version_group"
    }
}

struct FlavorText2 : Decodable
{
    let flavorText: String
    let language: Language
    let version: VersionGroup
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language = "language"
        case version = "version"
    }
}

struct Language : Decodable
{
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case name = "name"
  }
}

struct VersionGroup : Decodable
{
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case name = "name"
  }
}
