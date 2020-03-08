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
        userNameLabel.text = "@\(photo.userNameWhoPostedPicture)"
        postedDateLabel.text = photo.listedDate.description
    }
}
