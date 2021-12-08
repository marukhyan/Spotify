//
//  Artist.swift
//  Spotify
//
//  Created by David Marukhyan on 01.12.21.
//

import Foundation


struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
