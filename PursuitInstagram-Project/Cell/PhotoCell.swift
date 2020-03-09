//
//  PhotoCell.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/8/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    
    public func configureCell(for photo: Photo) {
        photoImage.kf.setImage(with: URL(string: photo.imageURL))
        photoNameLabel.text = photo.photoName
        userNameLabel.text = "Posted by user @\(photo.userNameWhoPostedPicture)"
        
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
//            print(displayFormatter.string(from: date))
            postedDateLabel.text = displayFormatter.string(from: date)
          print(photo.listedDate)
        }
    }
}
