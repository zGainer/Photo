//
//  PhotoViewController.swift
//  Photo
//
//  Created by Eugene on 28.06.23.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    let photo = UIImageView()
    
    let photographer = UILabel()
    let caption = UILabel()
    
    var presenter: PhotoPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Photo View Protocol

extension PhotoViewController: PhotoViewProtocol {

    func showPhoto(photoData: Data) {
        photo.image = UIImage(data: photoData)
    }

    func failure(error: Error) {
        print(error)
    }
}

// MARK: - Setup View

private extension PhotoViewController {
    
    func setupUI() {
        
        addViews()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension PhotoViewController {
    
    func addViews() {

        view.addSubview(photo)
        view.addSubview(photographer)
        view.addSubview(caption)
    }
    
    func configure() {

        view.backgroundColor = .white
        
        photo.contentMode = .scaleAspectFill

        caption.numberOfLines = 0
        caption.lineBreakMode = .byWordWrapping
        
        photographer.text = presenter.model.photographer
        caption.text = presenter.model.caption
    }
}

// MARK: - Layout

private extension PhotoViewController {
    
    func layout() {
        
        let ratio = CGFloat(presenter.model.height) / CGFloat(presenter.model.width)
        
        [photo, photographer, caption].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
        
            photo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: ratio),
            
            photographer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photographer.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 16),
            
            caption.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            caption.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            caption.topAnchor.constraint(equalTo: photographer.bottomAnchor, constant: 16)
        ])
    }
}
