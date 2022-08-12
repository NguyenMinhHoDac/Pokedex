//
//  Moves.swift
//  Pokedex
//
//  Created by SMin on 11/08/2022.
//

import Foundation

struct ListMove : Decodable
{
    let move: Move
    let versionDetail: [VersionDetail]
    
    enum CodingKeys: String, CodingKey {
        case move = "move"
        case versionDetail = "version_group_details"
    }
}

struct Move : Decodable
{
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

struct MoveDetail : Decodable
{
    let type: PokeType
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
    }
}

struct VersionDetail : Decodable
{
    let level: Int
    let version: VersionGroup
    
    enum CodingKeys: String, CodingKey {
        case level = "level_learned_at"
        case version = "version_group"
    }
}
