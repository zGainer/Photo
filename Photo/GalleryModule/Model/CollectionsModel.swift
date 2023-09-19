//
//  CollectionsModel.swift
//  Photo
//
//  Created by Eugene on 15.07.23.
//

struct CollectionsModel {
    
    let id: String
    let title: String
}

extension CollectionsModel {
    
    static func fetchCollections(from url: String, completion: @escaping([CollectionsModel]) -> Void) {
        
        DataManager.fetchData(from: url) { data in
            DataManager.decode(CollectionsData.self, from: data) { decoded in
                let collections = decoded.collections.map { CollectionsModel(id: $0.id,
                                                                             title: $0.title) }
                
                completion(collections)
            }
        }
    }
}
