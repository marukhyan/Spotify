//
//  PlayBackPresenter.swift
//  Spotify
//
//  Created by David Marukhyan on 16.12.21.
//

import UIKit

protocol playerDataSource: AnyObject {
    var songName: String? {get}
    var subtitle: String? {get}
    var imageURL: URL? {get}
    
}

final class PlayBackPresenter {
    
    static let shared = PlayBackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty{
            return tracks.first
        }
        return nil
    }
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        let vc = PlayerViewController()
        vc.title = track.name
        self.track = track
        self.tracks = []
        vc.dataSource = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
   func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
}

extension PlayBackPresenter: playerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}
