//
//  ShowDto.swift
//  StreamView
//
//  Created by Dark Matter on 07/07/22.
//

import Foundation


// MARK: - ShowDto
struct ShowDto: Codable {
    let id, name: String?
    let thumbnail: ImageDto?
    let cover, season, episode: JSONNull?
    let released, rating: String?
    let seasons: [SeasonDto]?
    let genre, casts, country, production: String?
    let showDtoDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, cover, season, episode, released, rating, seasons, genre, casts, country, production
        case showDtoDescription = "description"
    }
}

// MARK: - Season
struct SeasonDto: Codable {
    let id, name: String?
    let episodeCount: Int?
}
