//
//  VideoSource.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
struct ViewSource: Codable {
    let sources, sourcesBackup: [Source]
    let tracks: [Track]
}

// MARK: - Source
struct Source: Codable {
    let file: String
    let type: String
}

// MARK: - Track
struct Track: Codable {
    let file: String
    let label: String
    let kind: Kind
}

enum Kind: String, Codable {
    case captions = "captions"
}
