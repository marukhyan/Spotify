//
//  PlayerViewController.swift
//  Spotify
//
//  Created by David Marukhyan on 01.12.21.
//

import UIKit

final class PlayerViewController: UIViewController {
    
    private let controlsView = PlayerControlsView()
    weak var dataSource: playerDataSource?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: imageView.bottom + 10, width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func configure() {
        if dataSource?.imageURL != nil {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: (self.dataSource?.imageURL)!)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }
        controlsView.configure(with: PlayerControlsViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsViewDidTapPlayPause(_ playerCotrolsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDidTapForward(_ playerCotrolsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDidTapBackward(_ playerCotrolsView: PlayerControlsView) {
        
    }
}
