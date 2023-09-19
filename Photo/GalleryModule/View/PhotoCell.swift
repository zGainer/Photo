//
//  PhotoCell.swift
//  Photo
//
//  Created by Eugene on 13.06.23.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    let photo = UIImageView()
    let photographer = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View

private extension PhotoCell {
    
    func setupUI() {
        
        addViews()
        
        configure()
        
        layout()
    }
    
    func addViews() {
        
        contentView.addSubview(photo)
        contentView.addSubview(photographer)
    }
    
    func configure() {
        
        photo.contentMode = .scaleAspectFit
        
        photographer.textAlignment = .center
        photographer.backgroundColor = .white
    }
}

// MARK: - Layout

extension PhotoCell {
    
    func layout() {
        
        [photo, photographer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            photographer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photographer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photographer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
