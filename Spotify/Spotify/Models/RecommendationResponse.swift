//
//  RecommendationResponse.swift
//  Spotify
//
//  Created by David Marukhyan on 07.12.21.
//

import Foundation

struct RecommendationResponse: Codable {
    let tracks: [AudioTrack]
}
