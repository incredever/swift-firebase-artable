//
//  ViewController.swift
//  Artable
//
//  Created by Jonathan Sack on 9/21/19.
//  Copyright © 2019 Jonathan Sack. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginLogoutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    // MARK: - Variables
    var firebase: NSObjectProtocol?
    var categories = [Category]()
    var selectedCategory: Category?
    var db: Firestore!
    var listener: ListenerRegistration!

    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up DB
        db = Firestore.firestore()
        
        // Set up UI
        configureCollectionView()
//        setupNavigationBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupInitialUser()
        fetchCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firebase = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        Auth.auth().removeStateDidChangeListener(firebase!)
        categories.removeAll()
        self.collectionView.reloadData()
    }
    
    
    
    // MARK: - Functions
    fileprivate func setupNavigationBar() {
        // Set font
        guard let font = UIFont(name: "futura", size: 26) else {
            print("CUSTOM ERROR: Unable to load Navigation Bar Font")
            return
        }
        // Set attributes
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    func fetchCollection() {
        listener = db.categories.addSnapshotListener({ (snap, err) in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                default:
                    break
                }
            })
        })
    }
    
    func presentLoginVC() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginVC")
        present(controller, animated: true, completion: nil)
    }
    
    private func configureCollectionView() {
        // Set delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register XIB file
        let xib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    fileprivate func setupInitialUser() {
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginLogoutButton.title = "Logout"
        } else {
            loginLogoutButton.title = "Login"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toProductsVC" {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        }
    }

    
    
    // MARK: - IBActions
    @IBAction func loginLogoutButtonClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        if user.isAnonymous {
            presentLoginVC()
            
        } else {
            do {
                // Sign out  known user
                try Auth.auth().signOut()
                
                // Sign back in as anonymous
                Auth.auth().signInAnonymously { (_, error) in
                    
                    if let error = error {
                        self.handleFireAuthError(error: error)
                    }
    
                    self.presentLoginVC()
                }
            } catch {
                self.handleFireAuthError(error: error)
            }
        }

    
    }

}

// MARK: - EXTENSIONS
    // Firebase
extension HomeVC {
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        
        if change.oldIndex == change.newIndex {
            
            // Same index
            let index = Int(change.oldIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            
            // Different index
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
        
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
}

    // Collection View
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            cell.configureCell(category: self.categories[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 50) / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "toProductsVC", sender: self)
    }
}

// FETCH DOCUMENTS (OTHER METHODS)
//extension HomeVC {
//    func fetchDocument() {
//        let docRef = db.collection("categories").document("nS5e5YP8EtmCjaUKGa0Y")
//
//        listener = docRef.addSnapshotListener { (snap, error) in
//
//            guard let data = snap?.data() else {
//                return
//            }
//
//            let newCategory = Category(data: data)
//            self.categories.append(newCategory)
//
//            self.collectionView.reloadData()
//        }
//    }
//
//    func fetchCollection() {
//
//        let collectionRef = db.collection("categories")
//
//        listener = collectionRef.addSnapshotListener { (snap, err) in
//            // Error handling
//            guard err == nil else {
//                print("CUSTOM ERROR: Unable to fetch documents from database ~> \(err?.localizedDescription)")
//                return
//            }
//
//            // Get data
//            for document in snap!.documents {
//                let category = Category(data: document.data())
//                self.categories.append(category)
//            }
//
//            self.collectionView.reloadData()
//        }
//    }
//}
