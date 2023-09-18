//
//  DataManager.swift
//  Photo
//
//  Created by Eugene on 12.06.23.
//

import Foundation

struct DataManager {
    
    static func fetchData(from urlString: String, completion: @escaping(Data) -> Void) {
        
        NetworkManager.shared.fetchData(from: urlString) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func decode<T: Decodable>(_ type: T.Type, from data: Data, completion: (T) -> Void) {

        DecodeManager.shared.decode(T.self, from: data) { result in
            switch result {
            case .success(let decoded):
                completion(decoded)
            case .failure(let error):
                print(error)
            }
        }
    }
}
