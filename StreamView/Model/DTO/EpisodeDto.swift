//
//  EpisodeDto.swift
//  StreamView
//
//  Created by Dark Matter on 07/07/22.
//

import Foundation
struct EpisodeDto: Codable {
    let id, name: String?
}

typealias EpisodesDto = [EpisodeDto]
