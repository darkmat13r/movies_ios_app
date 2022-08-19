//
//  MovieDto.swift
//  StreamView
//
//  Created by Dark Matter on 06/07/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDto = try? newJSONDecoder().decode(MovieDto.self, from: jsonData)

import Foundation

// MARK: - MovieDto
struct MovieDto: Codable {
    let id, name, quality: String?
    let year: Int?
    let duration: String?
    let thumbnail, cover: ImageDto?
    let rating, released, genre, casts: String?
    let country, production, movieDtoDescription: String?
    let servers: [ServerDto]?

    enum CodingKeys: String, CodingKey {
        case id, name, quality, year, duration, thumbnail, cover, rating, released, genre, casts, country, production
        case movieDtoDescription = "description"
        case servers
    }
}

// MARK: - Cover
struct ImageDto: Codable {
    let url: String
}
