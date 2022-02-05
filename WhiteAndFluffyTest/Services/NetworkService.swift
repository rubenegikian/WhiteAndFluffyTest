//
//  NetworkService.swift
//  WhiteAndFluffyTest
//
//  Created by Ruben Egikian on 04.02.2022.
//

import Foundation

protocol NetworkService {
    func getRandomImages(completion: @escaping (Data?, Error?) -> Void)
    func getSearchImages(searchText: String, completion: @escaping (Data?, Error?) -> Void)
    func getInfoOfImage(id: String, completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkServiceImplementation: NetworkService {
    
    func getRandomImages(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = setupRandomParameters()
        let url = randomUrl(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func getSearchImages(searchText: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = setupSearchParameters(searchText: searchText)
        let url = searchUrl(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func getInfoOfImage(id: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = infoUrl(id: id)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    // MARK: - Supporting private functions
    
    private func setupHeader() -> [String: String]? {
        var headers = [String: String]()
        let accessKey = "SEt5QBZPdVuvtSDg_XxroS_53i159YBpfzlhYr2Fwr0"
        headers["Authorization"] = "Client-ID \(accessKey)"
        return headers
    }
    
    private func setupRandomParameters() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(30)
        return parameters
    }
    
    private func randomUrl(parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func setupSearchParameters(searchText: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchText
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    private func searchUrl(parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func infoUrl(id: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/\(id)"
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
