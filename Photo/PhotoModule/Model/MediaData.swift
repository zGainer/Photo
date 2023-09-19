//
//  MediaData.swift
//  Photo
//
//  Created by Eugene on 3.08.23.
//

// MARK: - Media Data

struct MediaData: Codable {
    
    let media: [Media]
}

// MARK: - Media

struct Media: Codable {
    
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let alt: String
    let src: Src
}
