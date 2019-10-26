//
//  Product.swift
//  Artable
//
//  Created by Jonathan Sack on 9/23/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var descr: String
    var imageUrl: String
    var timestamp: Timestamp
    var stock: Int
    var favorite: Bool
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0
        self.descr = data["descr"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
        self.favorite = data["favorite"] as? Bool ?? false
    }
}
