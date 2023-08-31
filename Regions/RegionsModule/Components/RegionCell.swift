//
//  RegionsCell.swift
//  Regions
//
//  Created by Ersan Shimshek on 30.08.2023.
//

import Foundation
import UIKit

class RegionCell: UITableViewCell {
    //MARK: Identifier
    static let cellID = "cellID"
    //MARK: - Properties
    private let imgView = UIImageView()
    private let nameLabel = UILabel()
    
    private var id: String?
    private var liked: Bool = false {
        didSet {
            if liked {
                stateButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: [])
            } else {
                stateButton.setImage(UIImage(systemName: "hand.thumbsup"), for: [])
            }
        }
    }
    private let stateButton = UIButton()
    
    //MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        nameLabel.text = nil
        id = nil
    }
}

//MARK: - Setup Constraints
extension RegionCell {
    private func setupConstraints(){
        
        //ImageView
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 6),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        //State Button
        contentView.addSubview(stateButton)
        stateButton.translatesAutoresizingMaskIntoConstraints = false
        stateButton.setImage(UIImage(systemName: "hand.thumbsup"), for: [])
        stateButton.addTarget(self, action: #selector(tapped), for: .touchDown)
        NSLayoutConstraint.activate([
            stateButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
            stateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stateButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            stateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        //Name Label
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.trailingAnchor.constraint(equalTo: stateButton.leadingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    //Configure cell
    
    func config(brand: Brand?) {
        guard let brand else { return }
        id = brand.brandId
        nameLabel.text = brand.title
        liked = LikeService.shared.likedIds.contains(brand.brandId)
        guard
            let preview = brand.thumbUrls.first
        else { return }
            
        NetworkService.shared.getFirstImage(url: preview) { [weak self] data in
            DispatchQueue.main.async {
                self?.imgView.image = UIImage(data: data)
            }
        }
    }
    
    //Selector Method
    @objc
    func tapped(){
        guard let id = id else { return }
        if !LikeService.shared.likedIds.contains(id){
            LikeService.shared.likedIds.insert(id)
            liked = true
        } else {
            LikeService.shared.likedIds.remove(id)
            liked = false
        }
    }
}
