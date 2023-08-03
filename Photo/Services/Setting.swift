//
//  Setting.swift
//  Photo
//
//  Created by Eugene on 12.06.23.
//

// Authorization is required for the Pexels API.
// Anyone with a Pexels account can request an API key, which you will receive instantly.
//
// https://www.pexels.com/api/new/
//
// All requests you make to the API will need to include your key.
// This is provided by adding an Authorization header.

import UIKit

struct Setting {
    
    static let authorizationKey = ApiKey.authorizationKey
    
    enum Links: String {
        case curated = "https://api.pexels.com/v1/curated"
        case collections = "https://api.pexels.com/v1/collections/featured"
        case collectionPhotos = "https://api.pexels.com/v1/collections/"
        
        func getLink(with id: String) -> String {
            
            return "\(rawValue)\(id)?type=photos"
        }
    }
    
    // MARK: Collection Views setting
    
    static let itemsPerRow: CGFloat = 2
    static let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    static func fetchCollectionLayout() -> UICollectionViewFlowLayout {

        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = sectionInserts
        layout.minimumLineSpacing = sectionInserts.left
        layout.minimumInteritemSpacing = sectionInserts.left

        return layout
    }
    
    static func getSizeOfCollectionItem(for collectionWidth: CGFloat) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionWidth - paddingWidth
        let widthPerItem = floor(availableWidth / itemsPerRow)
        let heightPerItem = widthPerItem
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}
