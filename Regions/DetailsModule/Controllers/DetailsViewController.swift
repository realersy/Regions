//
//  DetailsViewController.swift
//  Regions
//
//  Created by Ersan Shimshek on 30.08.2023.
//
import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 30
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collection
    }()
    let nameLabel = UILabel()
    let viewCountLabel = UILabel()
    let likeButton = UIButton()
    
    var galleryList: [Data]?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //Injected Properties
    var name: String?
    var viewCount: Int?
    var brandId: String?
    var thumbUrls: [String]?
    
    //Init
    init(brand: Brand?){
        super.init(nibName: nil, bundle: nil)
        guard let brand else { return }
        self.name = brand.title
        self.viewCount = brand.viewsCount
        self.brandId = brand.brandId
        self.thumbUrls = brand.thumbUrls
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        config()
        view.backgroundColor = .white
        startSpinner()
        NetworkService.shared.getImages(urlArray: thumbUrls!) { [weak self] dataArray in
            self!.galleryList = dataArray
            DispatchQueue.main.async {
                self?.stopSpinner()
                self?.collectionView.reloadData()
            }
        }
    }
}
//MARK: Setup
extension DetailsViewController {
    func setup() {
        //NameLabel
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 25)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //View Count Label
        viewCountLabel.font = UIFont(name: "Avenir Next", size: 17)
        viewCountLabel.textColor = .black
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewCountLabel)
        NSLayoutConstraint.activate([
            viewCountLabel.heightAnchor.constraint(equalToConstant: 30),
            viewCountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            viewCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            viewCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //Collection View
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            collectionView.topAnchor.constraint(equalTo: viewCountLabel.bottomAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //Like Button
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(tapped), for: .touchDown)
        view.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 60),
            likeButton.heightAnchor.constraint(equalToConstant: 60),
            likeButton.topAnchor.constraint(equalTo: viewCountLabel.bottomAnchor, constant: 15)
        ])
        
        //Spinner
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    //MARK: Configure UI
    private func config(){
        nameLabel.text = name
        viewCountLabel.text = " Просмотрено \(viewCount ?? -1) раз"
        
        guard let brandId else { return }
        if LikeService.shared.likedIds.contains(brandId) {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: [])
        } else {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: [])
        }
    }
    //MARK: Selector Method
    @objc
    func tapped(){
        guard let brandId = brandId else { return }
        if !LikeService.shared.likedIds.contains(brandId){
            LikeService.shared.likedIds.insert(brandId)
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: [])
        } else {
            LikeService.shared.likedIds.remove(brandId)
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: [])
        }
    }
}
//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.cellID, for: indexPath) as! GalleryCell
        cell.configImage(data: galleryList![indexPath.row])
        return cell
    }
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 1.7, height: 140)
    }
}

//MARK: Spinner
extension DetailsViewController {
    private func startSpinner(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func stopSpinner(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
