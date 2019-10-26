//
//  CategoryCell.swift
//  Artable
//
//  Created by Jonathan Sack on 9/23/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImage.layer.cornerRadius = LAYER.CORNER_RADIUS
    }
    
    
    // MARK: - Function(s)
    func configureCell(category: Category) {
        categoryLabel.text = category.name
        
        if let url = URL(string: category.imgUrl) {
            // Placeholder Image w/ Kingfisher
            let placeholder = UIImage(named: "placeholder")
            
            // Activity Indicator w/ Kingfisher
            categoryImage.kf.indicatorType = .activity
            
            // Options:
            let options: KingfisherOptionsInfo = [
                KingfisherOptionsInfoItem.transition(.fade(0.15))
            ]
            
            // Set image w/ Kingfisher
            categoryImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

}
