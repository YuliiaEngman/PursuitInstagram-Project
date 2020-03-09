//
//  PhotoFeedViewController.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/6/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PhotoFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var photos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        // register a .xib PhotoCell file
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
         listener = Firestore.firestore().collection(DatabaseService.photoCollection).addSnapshotListener({ [weak self] (snapshot, error) in
             if let error = error {
                 DispatchQueue.main.async {
                     self?.showAlert(title: "try again later", message: "\(error.localizedDescription)")
                 }
             } else if let snapshot = snapshot {
                 //print("there are \(snapshot.documents.count) item for sale")
                let photos = snapshot.documents.map { Photo($0.data())}
                 self?.photos = photos
             }
         })
     }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(true)
          listener?.remove() //no longer are we listening for changes from Firebase
      }
}

extension PhotoFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //FIXME: return photos.count
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
            fatalError("could not downcast to PhotoCell")
        }
        //FIXME: uncommect 2 lines of code bellow
        let savedPhoto = photos[indexPath.row]
       cell.configureCell(for: savedPhoto)
        return cell
    }
}


extension PhotoFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.50
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Segue to DetailVC
        
        let photo = photos[indexPath.row]
        let mainViewSB = UIStoryboard(name: "MainView", bundle: nil)
        let detailVC = mainViewSB.instantiateViewController(identifier: "DetailViewController") { coder in
            return DetailViewController(coder: coder, photo: photo)
        }
        //present in a navigation navigationController
       
        present(UINavigationController(rootViewController: detailVC), animated: true, completion: nil)
    }
}
