//
//  SearchResult.swift
//  Spotify
//
//  Created by David Marukhyan on 14.12.21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
