//
//  AddPhotoViewController.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/6/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddPhotoViewController: UIViewController {
    
 
    @IBOutlet weak var namePhotoTextField: UITextField!
    @IBOutlet weak var photoImage: UIImageView!
    
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private lazy var imagePickerController: UIImagePickerController = {
      let picker = UIImagePickerController()
      picker.delegate = self // confomrm to UIImagePickerContorllerDelegate and UINavigationControllerDelegate
      return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
      let gesture = UILongPressGestureRecognizer()
      gesture.addTarget(self, action: #selector(showPhotoOptions))
      return gesture
    }()
    
    private var selectedImage: UIImage? {
      didSet {
        photoImage.image = selectedImage
//        UIImage(data: <#T##Data#>)
//        photoImage.image = UIImage(named: "PhotoIcon")

      }
    }
    
//    init?(coder: NSCoder) {
//      super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Add Your Photo"
        namePhotoTextField.delegate = self
        
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(longPressGesture)

    }
    
    @objc private func showPhotoOptions() {
      let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
      let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true)
      }
      let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        alertController.addAction(cameraAction)
      }
      alertController.addAction(photoLibrary)
      alertController.addAction(cancelAction)
      present(alertController, animated: true)
    }

    @IBAction func postButtonPressed(_ sender: UIButton) {
        guard let photoName = namePhotoTextField.text?.capitalized, !photoName.isEmpty,
            let selectedPhoto = selectedImage else {
                showAlert(title: "Missing Fields", message: "All fields are required along with a photo.")
                return
        }

        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please complete your Profile.")
            return
        }
        
        // resize image before uploading to Storage
        let resizedImage = UIImage.resizeImage(originalImage: selectedPhoto, rect: photoImage.bounds)
        
        dbService.createPhoto(photoName: photoName, userPostedName: displayName) { [weak self](result) in
        switch result {
        case.failure(let error):
          DispatchQueue.main.async {
            self?.showAlert(title: "Error creating photo", message: "Sorry something went wrong: \(error.localizedDescription)")
          }
        case .success(let documentId):
          self?.uploadPhoto(photo: resizedImage, documentId: documentId)
          self?.showAlert2(message: "Your photo was successfully added to your photo collection")
        }
    }
       dismiss(animated: true)
}
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
      storageService.uploadPhoto(userId: documentId, photoId: documentId, image: photo) { [weak self] (result) in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
          }
        case .success(let url):
          self?.updateItemImageURL(url, documentId: documentId)
        }
      }
    }
    
    private func updateItemImageURL(_ url: URL, documentId: String) {
      // update an existing document on Firebase
      Firestore.firestore().collection(DatabaseService.photoCollection).document(documentId).updateData(["imageURL" : url.absoluteString]) { [weak self] (error) in
        if let error = error {
          DispatchQueue.main.async {
            self?.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
          }
        } else {
          // everything went ok
          print("all went well with the update")
          DispatchQueue.main.async {
            self?.dismiss(animated: true)
          }
        }
      }
    }
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
        fatalError("could not attain original image")
      }
      selectedImage = image
      dismiss(animated: true)
    }
}

extension AddPhotoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
