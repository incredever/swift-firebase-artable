//
//  ProductCell.swift
//  Artable
//
//  Created by Jonathan Sack on 9/23/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productFavStar: UIButton!
    
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    // MARK: - Function
    func configureCell(product: Product) {
        productTitle.text = product.name
        productPrice.text = "$\(String(product.price))"
        
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
        
    }
    
    
    // MARK: - IBActions
    @IBAction func addToCartButtonClicked(_ sender: Any) {
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
    }
    
    
}
