//
//  NetworkDataFetcher.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import Foundation

final class NetworkDataFetcher {
    var networkService: NetworkService!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchSearchImages(searchText: String, completion: @escaping (SearchResults?) -> Void) {
        networkService.getSearchImages(searchText: searchText) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = Self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
    
    func fetchRandomImages(completion: @escaping ([SingleImage]?) -> Void) {
        networkService.getRandomImages { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = Self.decodeJSON(type: [SingleImage].self, from: data)
            completion(decode)
        }
    }
    
    func fetchDetailedImage(id: String?, completion: @escaping (DetailedImage?) -> Void) {
        guard let id = id else { return }
        networkService.getInfoOfImage(id: id) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = Self.decodeJSON(type: DetailedImage.self, from: data)
            completion(decode)
        }
    }
    
    static func decodeJSON<T: Codable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        do {
            let objects = try decoder.decode(T.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode", jsonError)
            return nil
        }
    }
}
