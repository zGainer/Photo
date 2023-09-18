//
//  GalleryPresenter.swift
//  Photo
//
//  Created by Eugene on 13.09.23.
//

import Foundation

protocol GalleryViewProtocol: AnyObject {
    
    func showPhoto()
    func setSegmentedControlTitle(_ title: String)
    func failure(error: Error)
}

final class GalleryPresenter {
    
    private let view: GalleryViewController
    
    var photos: [photoSet] = []
    
    struct photoSet {
        let model: PhotoModel
        var photoData: Data
    }
    
    private var collections: [CollectionsModel]!

    required init(view: GalleryViewController) {
        self.view = view
        
        fetchCollections()
    }
}

extension GalleryPresenter {

    private func fetchCollections () {
        
        let link = Setting.Links.collections.rawValue
        
        CollectionsModel.fetchCollections(from: link) { [unowned self] fetchedCollections in
            collections = fetchedCollections
        }
    }
    
    private func fetchImages(from models: [PhotoModel]) {
        
        for model in models {
            NetworkManager.shared.fetchImage(url: model.previewUrl) { [unowned self] result in
                switch result {
                case .success(let data):
                    photos.append(photoSet(model: model,
                                           photoData: data))
                    view.showPhoto()
                case .failure(let error):
                    view.failure(error: error)
                }
            }
        }
    }
    
    func fetchMedia() {
        
        guard let model = collections.randomElement() else { return }
        
        view.setSegmentedControlTitle(model.title)
        
        let link = Setting.Links.collectionPhotos.getLink(with: model.id)
        
        PhotoModel.fetchMedia(from: link) { [unowned self] photos in
            fetchImages(from: photos)
        }
    }
    
    func fetchPhotos() {
        
        view.setSegmentedControlTitle("Random")
        
        let link = Setting.Links.curated.rawValue
        
        PhotoModel.fetchPhotos(from: link) { [unowned self] photos in
            fetchImages(from: photos)
        }
    }
}
