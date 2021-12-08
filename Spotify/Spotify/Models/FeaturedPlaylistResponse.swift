//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by David Marukhyan on 07.12.21.
//

import Foundation
struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}


struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
