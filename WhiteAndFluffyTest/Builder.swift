//
//  Builder.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import Foundation
import UIKit

final class Builder {
    static let shared = Builder()
    
    func buildTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        let networkService = NetworkServiceImplementation()
        let networkDataFetcher = NetworkDataFetcher(networkService: networkService)
        let viewControllers = [buildImagesViewController(networkDataFetcher: networkDataFetcher), buildFavouritesViewController()]
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.tabBar.tintColor = .systemIndigo
        tabBarController.tabBar.backgroundColor = .systemBackground
        return tabBarController
    }
    
    private func buildImagesViewController(networkDataFetcher: NetworkDataFetcher) -> UIViewController {
        let navigationController = UINavigationController()
        let viewController = ImagesViewController(networkDataFetcher: networkDataFetcher)
        navigationController.viewControllers = [viewController]
        let imageItem = UITabBarItem(title: "Images", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), selectedImage: nil)
        viewController.tabBarItem = imageItem
        viewController.title = "Images"
        viewController.view.backgroundColor = .systemBackground
        return navigationController
    }
    
    private func buildFavouritesViewController() -> UIViewController {
        let navigationController = UINavigationController()
        let viewController = FavouritesViewController()
        navigationController.viewControllers = [viewController]
        let imageItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart"), selectedImage: nil)
        viewController.tabBarItem = imageItem
        viewController.title = "Favourites"
        viewController.view.backgroundColor = .systemBackground
        return navigationController
    }
}
