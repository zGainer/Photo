//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Eugene on 10.06.23.
//

import Foundation

final class NetworkManager: Error {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
    
    func fetchData(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue(Setting.authorizationKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data {
                completion(.success(data))
            } else {
                completion(.failure(.noData))
            }
            
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {

        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))

            return
        }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))

                return
            }

            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
