//
//  ViewController.swift
//  Photo
//
//  Created by Eugene on 10.06.23.
//

import UIKit

final class GalleryViewController: UIViewController {

    private var gallery: UICollectionView!
    
    private let galleryStack = UIStackView()
    
    private let segmentedControl = UISegmentedControl()
    
    private let reuseIdentifier = "PhotoCell"
    
    private var collections: [CollectionsModel] = []
    
    private var photos: [photoSet] = []
    
    private struct photoSet {
        let model: PhotoModel
        var photo: UIImage?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - UI Collection View Data Source

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCell else { fatalError("Error cast PhotoCell") }
        
        cell.photo.image = photos[indexPath.row].photo
        cell.photographer.text = photos[indexPath.row].model.photographer
        
        return cell
    }
}

// MARK: - UI Collection View Delegate

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoVC = PhotoViewController()
        
        photoVC.model = photos[indexPath.row].model
        
        navigationController?.pushViewController(photoVC, animated: true)
    }
}

// MARK: - Collection View Delegate Flow Layout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizeForItem = Setting.getSizeOfCollectionItem(for: collectionView.frame.width)
        
        return sizeForItem
    }
}

// MARK: - Common

private extension GalleryViewController {
    
    func fetchPhotos() {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            guard let model = collections.randomElement() else { fatalError("No collection id") }
            
            segmentedControl.setTitle(model.title, forSegmentAt: 1)
            
            let link = Setting.Links.collectionPhotos.getLink(with: model.id)
            
            PhotoModel.fetchMedia(from: link) { [unowned self] photos in
                fetchImages(from: photos)
            }
        } else {
            segmentedControl.setTitle("Random", forSegmentAt: 1)
            
            let link = Setting.Links.curated.rawValue
            
            PhotoModel.fetchPhotos(from: link) { [unowned self] photos in
                fetchImages(from: photos)
            }
        }
    }
    
    func fetchImages(from models: [PhotoModel]) {
        
        photos.removeAll()
        
        for model in models {
            NetworkManager.shared.fetchImage(url: model.previewUrl) { [unowned self] result in
                switch result {
                case .success(let data):
                    showPhoto(for: model, from: data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func showPhoto(for model: PhotoModel, from data: Data) {
        
        let image = UIImage(data: data)
        
        photos.append(photoSet(model: model,
                               photo: image))
        
        gallery.reloadData()
    }
    
    func fetchCollections () {
        
        let link = Setting.Links.collections.rawValue
        
        CollectionsModel.fetchCollections(from: link) { [unowned self] fetchedCollections in
            collections = fetchedCollections
        }
    }
}

// MARK: - Setup View

private extension GalleryViewController {
    
    func setupUI() {
        
        createViews()
        
        addViews()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension GalleryViewController {
    
    func createViews() {
        
        let layout = Setting.fetchCollectionLayout()
        
        gallery = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        
        gallery.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func addViews() {
        
        view.addSubview(segmentedControl)
        view.addSubview(galleryStack)
        
        galleryStack.addSubview(gallery)
    }
    
    func configure() {

        gallery.delegate = self
        gallery.dataSource = self

        view.backgroundColor = .white

        navigationItem.title = "Pexels"

        let curatedAction = UIAction(title: "Curated") { [unowned self] _ in fetchPhotos() }
        let randomAction = UIAction(title: "Random") { [unowned self] _ in fetchPhotos() }
        
        segmentedControl.insertSegment(action: curatedAction, at: 0, animated: false)
        segmentedControl.insertSegment(action: randomAction, at: 1, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        
        fetchCollections()
        fetchPhotos()
    }
}

// MARK: - Layout

private extension GalleryViewController {
    
    func layout() {
        
        [segmentedControl, galleryStack, gallery].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
        
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            galleryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryStack.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            galleryStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gallery.leadingAnchor.constraint(equalTo: galleryStack.leadingAnchor),
            gallery.trailingAnchor.constraint(equalTo: galleryStack.trailingAnchor),
            gallery.topAnchor.constraint(equalTo: galleryStack.topAnchor),
            gallery.bottomAnchor.constraint(equalTo: galleryStack.bottomAnchor)
        ])
    }
}
