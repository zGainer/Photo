//
//  PhotoModel.swift
//  Photo
//
//  Created by Eugene on 10.06.23.
//

struct PhotoModel {
    
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let caption: String
    let previewUrl: String
    let originalUrl: String
}

extension PhotoModel {
    
    static func fetchPhotos(from url: String, completion: @escaping([PhotoModel]) -> Void) {
        
        DataManager.fetchData(from: url) { data in
            DataManager.decode(PhotoData.self, from: data) { photoData in

                let photos = photoData.photos.map { PhotoModel(width: $0.width,
                                                               height: $0.height,
                                                               url: $0.url,
                                                               photographer: $0.photographer,
                                                               caption: $0.alt,
                                                               previewUrl: $0.src.large,
                                                               originalUrl: $0.src.original) }

                completion(photos)
            }
        }
    }
    
    static func fetchMedia(from url: String, completion: @escaping([PhotoModel]) -> Void) {
        
        DataManager.fetchData(from: url) { data in
            DataManager.decode(MediaData.self, from: data) { mediaData in
                
                let photos = mediaData.media.map { PhotoModel(width: $0.width,
                                                              height: $0.height,
                                                              url: $0.url,
                                                              photographer: $0.photographer,
                                                              caption: $0.alt,
                                                              previewUrl: $0.src.large,
                                                              originalUrl: $0.src.original) }
                
                completion(photos)
            }
        }
    }
}
