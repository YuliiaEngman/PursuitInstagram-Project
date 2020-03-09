//
//  ProfileViewController.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/6/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var displayUsernameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            profileImageView.image = selectedImage
        }
    }
    
    private let storageservice = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayUsernameTextField.delegate = self
        updateUI()
    }
    
    private func updateUI() {
           guard let user = Auth.auth().currentUser else {
               return
           }
           emailLabel.text = user.email
           displayUsernameTextField.text = user.displayName
           profileImageView.kf.setImage(with: user.photoURL)
       }
    
    @IBAction func userphotoUpdateButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        { [weak self] alertAction in
            self?.imagePickerController.sourceType = .camera
            self?.present(self!.imagePickerController, animated: true)
        }
        let phototLibararyAction = UIAlertAction(title: "Photo Libarary", style: .default)
        { [weak self] alertAction in
            self?.imagePickerController.sourceType = .photoLibrary
            self?.present(self!.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(phototLibararyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    @IBAction func updateUserProfileButtonPressed(_ sender: UIButton) {
        //change the user's display name
          
          guard let displayName = displayUsernameTextField.text,
              !displayName.isEmpty, let selectedImage = selectedImage else {
                  print("missing field")
                  return
          }
          
          guard let user = Auth.auth().currentUser else { return }
          //resize image before uploading to Firebase
          let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImageView.bounds)
          
          print("original image size: \(selectedImage.size)")
          print("resized image size: \(resizedImage)")
          
          //TODO: call storageService.upload
          //need to update to user userId ot itemId
          storageservice.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
              // code here to add the photoURL to the user's photoURL
              //     property then commit changes
              switch result {
              case .failure(let error):
                  DispatchQueue.main.async {
                      self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                  }
              case .success(let url):
                  let request = Auth.auth().currentUser?.createProfileChangeRequest()
                  request?.displayName = displayName
                  request?.photoURL = url
                  request?.commitChanges(completion: { [unowned self] (error) in
                      if let error = error {
                          //TODO: show alert
                          //print("CommitCjanges error: \(error)")
                          DispatchQueue.main.async {
                              self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription)")
                          }
                      } else {
                          //print("profile successfully updated")
                          DispatchQueue.main.async {
                              self?.showAlert(title: "Profile Updated", message: "Profile successfully updated")
                          }
                      }
                  })
              }
          }
    }
    
    @IBAction func signoutButtonPressed(_ sender: UIButton) {
       
        do {
               try Auth.auth().signOut()
               UIViewController.showViewController(storyboardName: "LoginViewStoryboard", viewControllerId: "LoginViewController")
           } catch {
               DispatchQueue.main.async {
                   self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
               }
           }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
