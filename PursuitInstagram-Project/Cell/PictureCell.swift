//
//  PictureCell.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/8/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    
    public func configureCell(for picture: Photo) {
        pictureImage.kf.setImage(with: URL(string: picture.imageURL))
        imageNameLabel.text = picture.pictureName
        userNameLabel.text = "@\(picture.userNameWhoPostedPicture)"
        postedDateLabel.text = picture.listedDate.description
    }
}
