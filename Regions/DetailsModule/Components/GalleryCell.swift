//
//  GalleryCell.swift
//  Regions
//
//  Created by Ersan Shimshek on 31.08.2023.
//

import Foundation
import UIKit

class GalleryCell: UICollectionViewCell {
    //MARK: Cell Identifier
    static let cellID = "GalleryCell"
    
    private let imgView = UIImageView()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup
extension GalleryCell {
    private func setup(){
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.frame = contentView.bounds
        contentView.backgroundColor = .gray
    }
    
    func configImage(data: Data){
        imgView.image = UIImage(data: data)
    }
}
