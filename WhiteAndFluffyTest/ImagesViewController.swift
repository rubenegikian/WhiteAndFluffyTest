//
//  ImagesViewController.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import UIKit

final class ImagesViewController: UIViewController {
    
    private let networkDataFetcher: NetworkDataFetcher
    private var timer: Timer?
    private var images = [Image]()
    private var randomImages = [Image]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        return collection
    }()
    
    init(networkDataFetcher: NetworkDataFetcher) {
        self.networkDataFetcher = networkDataFetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupSearchBar()
        setupRandomImages()
    }
    
    private func setupRandomImages() {
        self.networkDataFetcher.fetchRandomImages { [weak self] (randomSingleImages) in
            guard let self = self else { return }
            guard let fetchedImages = randomSingleImages else { return }
            DispatchQueue.main.async {
                self.randomImages = fetchedImages
                self.images = fetchedImages
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Layout

extension ImagesViewController {
    private func setupLayout () {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}

// MARK: - CollectionView

extension ImagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else {
            return .init()
        }
        let singleImage = images[indexPath.row]
        cell.singleImage = singleImage as? SingleImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = images[indexPath.row] as? SingleImage else { return CGSize(width: 100, height: 250) }
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(image.height) * widthPerItem / CGFloat(image.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let image = images[indexPath.row] as? SingleImage else { return }
        let id = image.id
        let infoVC = ImageInfoViewController()
        networkDataFetcher.fetchDetailedImage(id: id) { [weak self] (detailedImage) in
            guard let self = self else { return }
            guard let fetchedImage = detailedImage else { return }
            DispatchQueue.main.async {
                infoVC.detailedImage = fetchedImage
                self.present(infoVC, animated: true)
            }
        }
    }
}

// MARK: - SeachBarDelegate

extension ImagesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            if searchText.count == 0 || searchText == " " {
                DispatchQueue.main.async {
                    self.images = self.randomImages
                    self.collectionView.reloadData()
                }
            } else {
                self.networkDataFetcher.fetchSearchImages(searchText: searchText) { [weak self] (searchResults) in
                    guard let self = self else { return }
                    guard let fetchedImages = searchResults else { return }
                    DispatchQueue.main.async {
                        self.images = fetchedImages.results
                        self.collectionView.reloadData()
                    }
                }
            }
        })
    }
}
