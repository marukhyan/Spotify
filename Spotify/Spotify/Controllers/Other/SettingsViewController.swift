//
//  SettingsViewController.swift
//  Spotify
//
//  Created by David Marukhyan on 01.12.21.
//

import UIKit

final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureModels() {
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: {
            DispatchQueue.main.async {
                self.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sigh Out", handler: {
            DispatchQueue.main.async {
                self.signOutTapped()
            }
        })]))
    }
    
    private func signOutTapped() {
        AuthManager.shared.signOut { [weak self] sighOut in
            if sighOut {
                DispatchQueue.main.async {
                    
                    let navVC = UINavigationController(rootViewController: WelcomeViewController())
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: {
                        self?.navigationController?.popToRootViewController(animated: false)
                    })
                }
            }
        }
    }
    
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
}
