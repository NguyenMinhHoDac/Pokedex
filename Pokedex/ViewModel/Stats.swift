//
//  File.swift
//  Pokedex
//
//  Created by SMin on 08/08/2022.
//

struct ListStat : Decodable
{
    let baseStat: Int
    let stat: Stat
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat = "stat"
    }
}

struct Stat : Decodable
{
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

