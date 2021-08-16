//
//  VideoSource.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
struct ViewSource: Codable {
    let sources1, sources2: [Sources]
    let tracks: [Track]

    enum CodingKeys: String, CodingKey {
        case sources1 = "sources_1"
        case sources2 = "sources_2"
        case tracks
    }
}

// MARK: - Sources
struct Sources: Codable {
    let file: String
    let type, label: String
}

// MARK: - Track
struct Track: Codable {
    let file: String
    let label, kind: String
}
