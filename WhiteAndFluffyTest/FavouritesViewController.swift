//
//  FavouritesViewController.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import Foundation
import UIKit

final class FavouritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.reuseId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Layout

extension FavouritesViewController {
    private func setupLayout () {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
// MARK: - TableView

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavouriteImages.favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.reuseId, for: indexPath) as? FavouritesTableViewCell else { return .init() }
        let favouriteImage = FavouriteImages.favourites[indexPath.row]
        cell.favouriteImage = favouriteImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedImage = FavouriteImages.favourites[indexPath.row]
        let infoVC = ImageInfoViewController()
        infoVC.detailedImage = detailedImage
        infoVC.delegate = self
        present(infoVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        FavouriteImages.favourites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}

// MARK: - ImageInfoDelegate

extension FavouritesViewController: ImageInfoDelegate {
    func didChangeFavouritesList() {
        tableView.reloadData()
    }
}
