//
//  ImageResults.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import Foundation

protocol Image {
    var id: String { get }
}

struct SearchResults: Codable {
    let total: Int
    let results: [SingleImage]
}

struct SingleImage: Image, Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: [URLForSize.RawValue:String]
    
    enum URLForSize: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
    }
}

struct DetailedImage: Image, Codable {
    let id: String
    let createdAt: String
    let downloads: Int
    let location: Location?
    let user: User
    let urls: [URLForSize.RawValue:String]
    
    enum URLForSize: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case downloads
        case location
        case user
        case urls
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(String.self, forKey: .id)
        self.createdAt = try map.decode(String.self, forKey: .createdAt)
        self.downloads = try map.decode(Int.self, forKey: .downloads)
        self.location = try? map.decode(Location.self, forKey: .location)
        self.user = try map.decode(User.self, forKey: .user)
        self.urls = try map.decode([URLForSize.RawValue:String].self, forKey: .urls)
    }
}

struct User: Codable {
    let name: String
}

struct Location: Codable {
    var city: String
    var country: String
}

var favourites = [DetailedImage]()
