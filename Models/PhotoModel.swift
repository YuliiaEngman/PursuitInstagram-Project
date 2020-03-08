//
//  PictureModel.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/8/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import Foundation

struct Photo {
    let imageURL: String
    let pictureName: String
    let pictureId: String
    let listedDate: Date
    let userNameWhoPostedPicture: String
    let userIdWhoPostedPicture: String
}

extension Photo {
    init(_ dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
        self.pictureName = dictionary["pictureName"] as? String ?? "no picture name"
        self.pictureId = dictionary["pictureId"] as? String ?? "no pictureId"
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
        self.userNameWhoPostedPicture = dictionary["userNameWhoPostedPicture"] as? String ?? "no user name"
        self.userIdWhoPostedPicture = dictionary["userIdWhoPostedPicture"] as? String ?? "no user ID"
    }
}
