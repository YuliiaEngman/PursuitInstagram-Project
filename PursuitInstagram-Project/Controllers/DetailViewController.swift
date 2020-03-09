//
//  DetailViewController.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/8/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var photo: Photo
    
    init?(coder: NSCoder, photo: Photo) {
      self.photo = photo
      super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo Detail"
        
        photoNameLabel.text = photo.photoName
        userNameLabel.text = "User who posted photo: \(photo.userNameWhoPostedPicture)"
       // dateLabel.text = photo.listedDate
        photoImageView.kf.setImage(with: URL(string: photo.imageURL))
        
        //PART 1:
              //format of the date what we have right now!
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
              //we having "yyyy-MM-dd HH:mm:ss +0000" // +0000=z
              if let date = formatter.date(from: photo.listedDate.description) {
                  print(date)
                  
                  //PART 2:
                  //tiping format of date that we want to get!
                  let displayFormatter = DateFormatter()
                  displayFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                  print(displayFormatter.string(from: date))
                  dateLabel.text = displayFormatter.string(from: date)
              }
    }
}
