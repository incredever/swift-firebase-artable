//
//  ProductsVC.swift
//  Artable
//
//  Created by Jonathan Sack on 9/23/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class ProductsVC: UIViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var db: Firestore!
    var firebase: NSObjectProtocol?
    var listener: ListenerRegistration!
    var products = [Product]()
    var category: Category!
    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up DB
        db = Firestore.firestore()
        
        // Register XIB(s)
        let xib = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "ProductCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firebase = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchProducts(from: category)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        Auth.auth().removeStateDidChangeListener(firebase!)
        products.removeAll()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Functions
    func fetchProducts(from category: Category) {
        listener = db.cars.addSnapshotListener({ (snap, err) in
           
            if let error = err {
                print("CUSTOM ERROR: Unable to fetch products from Database ~> \(error.localizedDescription)")
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let product = Product(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                default:
                    break
                }
            })
        })
    }


}

// MARK: - EXTENSIONS
// Firebase
extension ProductsVC {
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: UITableView.RowAnimation.bottom)
//        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        
        if change.oldIndex == change.newIndex {
            
            // Same index
            let index = Int(change.oldIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableView.RowAnimation.fade)
//            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            
            // Different index
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
//            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
        
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: UITableView.RowAnimation.left)
//        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
}

    // Collection View
extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}
