//
//  ImageInfoViewController.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import Foundation
import UIKit
import SDWebImage

protocol ImageInfoDelegate: AnyObject {
    func didChangeFavouritesList()
}

final class ImageInfoViewController: UIViewController {
    weak var delegate: ImageInfoDelegate?
    
    var detailedImage: DetailedImage! {
        didSet {
            let imageUrl = detailedImage.urls["regular"]
            guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
            authorLabel.text = detailedImage.user.name
            locationLabel.text = "\(detailedImage.location?.city ?? "Unknown city"), \(detailedImage.location?.country ?? "Unknown country")"
            downloadsLabel.text = "Downloads: \(detailedImage.downloads)"
            setupDate(date: detailedImage.createdAt)
            for image in favourites {
                if image.id == detailedImage.id {
                    isFavourite = true
                    buttonChange(isFavourite: isFavourite)
                }
            }
        }
    }
    
    private var isFavourite: Bool = false
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var locationSignImageView: UIImageView = {
        let image = UIImage(systemName: "mappin.and.ellipse")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addToFavouritesButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to favourites", for: .normal)
        button.backgroundColor = .systemIndigo
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    private func buttonChange(isFavourite: Bool) {
        if isFavourite {
            addToFavouritesButton.setTitle("Remove from favourites", for: .normal)
            addToFavouritesButton.backgroundColor = .red
        } else {
            addToFavouritesButton.setTitle("Add to favourites", for: .normal)
            addToFavouritesButton.backgroundColor = .systemIndigo
        }
    }
    
    private func setupDate(date: String) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        createdAtLabel.text = resultString
    }
    
    private func setupLayout() {
        [imageView, locationSignImageView, authorLabel, locationLabel, downloadsLabel, createdAtLabel, addToFavouritesButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.3),
            
            createdAtLabel.topAnchor.constraint(equalTo: locationSignImageView.topAnchor),
            createdAtLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            createdAtLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createdAtLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationSignImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            locationSignImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            locationSignImageView.widthAnchor.constraint(equalToConstant: 20),
            locationSignImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.topAnchor.constraint(equalTo: locationSignImageView.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationSignImageView.trailingAnchor, constant: 6),
            locationLabel.trailingAnchor.constraint(equalTo: createdAtLabel.leadingAnchor, constant: -16),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            authorLabel.topAnchor.constraint(equalTo: locationSignImageView.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: locationSignImageView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authorLabel.heightAnchor.constraint(equalToConstant: 40),
            
            downloadsLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 6),
            downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            downloadsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            addToFavouritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToFavouritesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            addToFavouritesButton.heightAnchor.constraint(equalToConstant: 40),
            addToFavouritesButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }

}

// MARK: Selectors

extension ImageInfoViewController {
    @objc
    private func didTapButton() {
        if isFavourite {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to remove this image from favourites?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {_ in
                self.isFavourite = false
                self.addToFavouritesButton.setTitle("Add to favourites", for: .normal)
                self.addToFavouritesButton.backgroundColor = .systemIndigo
                for index in 0..<favourites.count {
                    if favourites[index].id == self.detailedImage.id {
                        favourites.remove(at: index)
                        self.delegate?.didChangeFavouritesList()
                        break
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            isFavourite = true
            addToFavouritesButton.setTitle("Remove from favourites", for: .normal)
            addToFavouritesButton.backgroundColor = .red
            favourites.append(detailedImage)
            self.delegate?.didChangeFavouritesList()
        }
    }
}
