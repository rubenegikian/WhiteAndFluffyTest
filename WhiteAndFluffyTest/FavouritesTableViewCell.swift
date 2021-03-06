//
//  FavouritesTableViewCell.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 05.02.2022.
//

import Foundation
import UIKit

final class FavouritesTableViewCell: UITableViewCell {
    
    static let reuseId = "FavouriteCell"
    
    var favouriteImage: DetailedImage! {
        didSet {
            let favouriteImageUrl = favouriteImage.urls["thumb"]
            guard let imageUrl = favouriteImageUrl, let url = URL(string: imageUrl) else { return }
            smallImageView.sd_setImage(with: url, completed: nil)
            smallAuthorLabel.text = favouriteImage.user.name
        }
    }
    
    private lazy var smallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var smallAuthorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(smallImageView)
        addSubview(smallAuthorLabel)
        
        NSLayoutConstraint.activate([
            smallImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            smallImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            smallImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            smallImageView.heightAnchor.constraint(equalToConstant: 38),
            
            smallAuthorLabel.heightAnchor.constraint(equalToConstant: 38),
            smallAuthorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            smallAuthorLabel.leadingAnchor.constraint(equalTo: smallImageView.trailingAnchor, constant: 14),
            smallAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6)
        ])
    }
}
