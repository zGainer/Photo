//
//  PhotoPresenter.swift
//  Photo
//
//  Created by Eugene on 12.09.23.
//

import Foundation

protocol PhotoViewProtocol: AnyObject {
    
    func showPhoto(photoData: Data)
    func failure(error: Error)
}

protocol PhotoViewPresenterProtocol {
    
    var model: PhotoModel { get }
    
    init(view: PhotoViewController, model: PhotoModel)
    
    func fetchPhoto()
}

final class PhotoPresenter: PhotoViewPresenterProtocol {
    
    private let view: PhotoViewController
    
    let model: PhotoModel
    
    required init(view: PhotoViewController, model: PhotoModel) {
        self.view = view
        self.model = model
        
        fetchPhoto()
    }
    
    func fetchPhoto() {
        
        NetworkManager.shared.fetchImage(url: model.originalUrl) { [unowned self] result in
            switch result {
            case .success(let data):
                view.showPhoto(photoData: data)
            case .failure(let error):
                view.failure(error: error)
            }
        }
    }
}
