//
//  CollectionData.swift
//  Photo
//
//  Created by Eugene on 15.07.23.
//

struct CollectionsData: Codable {
    
    let collections: [collections]
}

struct collections: Codable {
    
    let id: String
    let title: String
}
