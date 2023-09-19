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
    
    private var presenter: GalleryPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - UI Collection View Data Source

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCell else { fatalError("Error cast PhotoCell") }
        
        let photo = UIImage(data: presenter.photos[indexPath.row].photoData)
        
        cell.photo.image = photo
        cell.photographer.text = presenter.photos[indexPath.row].model.photographer
        
        return cell
    }
}

// MARK: - UI Collection View Delegate

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = presenter.photos[indexPath.row].model
        
        let photoVC = PhotoViewController()
        
        photoVC.presenter = PhotoPresenter(view: photoVC, model: model)
        
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

// MARK: - Gallery View Protocol

extension GalleryViewController: GalleryViewProtocol {
    
    func fetchPhotos() {
        
        presenter.photos.removeAll()
        
        if segmentedControl.selectedSegmentIndex == 1 {
            presenter.fetchMedia()
        } else {
            presenter.fetchPhotos()
        }
    }
    
    func setSegmentedControlTitle(_ title: String) {
        
        segmentedControl.setTitle(title, forSegmentAt: 1)
    }
    
    func showPhoto() {
        
        gallery.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
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

        presenter = GalleryPresenter(view: self)
        
        gallery.delegate = self
        gallery.dataSource = self

        view.backgroundColor = .white

        navigationItem.title = "Pexels"

        let curatedAction = UIAction(title: "Curated") { [unowned self] _ in fetchPhotos() }
        let randomAction = UIAction(title: "Random") { [unowned self] _ in fetchPhotos() }
        
        segmentedControl.insertSegment(action: curatedAction, at: 0, animated: false)
        segmentedControl.insertSegment(action: randomAction, at: 1, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        
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
