//
//  PhotoData.swift
//  Photo
//
//  Created by Eugene on 10.06.23.
//

// MARK: - Photo Data

struct PhotoData: Codable {
    
    let photos: [Photo]
}

// MARK: - Photo

struct Photo: Codable {
    
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let alt: String
    let src: Src
}

// MARK: - Src

struct Src: Codable {
    
    let large: String
    let original: String
}
