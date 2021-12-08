//
//  Playlist.swift
//  Spotify
//
//  Created by David Marukhyan on 01.12.21.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
