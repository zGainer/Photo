//
//  DecodeManager.swift
//  Photo
//
//  Created by Eugene on 10.06.23.
//

import Foundation

final class DecodeManager {
    
    static let shared = DecodeManager()
    
    private init() {}
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data, completion: (Result<T, Error>) -> Void) {
        
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decoded = try decoder.decode(type, from: data)

            completion(.success(decoded))
        } catch {
            completion(.failure(error))
        }
    }
}
