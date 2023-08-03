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
    
    var model: PhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
        
        guard let model else { return }
        
        view.backgroundColor = .white
        
        photo.contentMode = .scaleAspectFill
        
        photographer.text = model.photographer
        caption.text = model.caption
        
        caption.numberOfLines = 0
        caption.lineBreakMode = .byWordWrapping
        
        NetworkManager.shared.fetchImage(url: model.originalUrl) { [unowned self] result in
            switch result {
            case .success(let data):
                photo.image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Layout

private extension PhotoViewController {
    
    func layout() {
        
        var ratio: CGFloat = 1
        
        if let model {
            ratio = CGFloat(model.height) / CGFloat(model.width)
        }
        
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
