//
//  ServerDto.swift
//  StreamView
//
//  Created by Dark Matter on 07/07/22.
//

import Foundation
struct ServerDto: Codable {
    let url: String?
    let name: String?
}

typealias ServersDto = [ServerDto]
