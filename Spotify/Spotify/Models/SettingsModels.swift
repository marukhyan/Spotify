//
//  SettingsModels.swift
//  Spotify
//
//  Created by David Marukhyan on 06.12.21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}


