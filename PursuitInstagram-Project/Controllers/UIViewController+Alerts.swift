//
//  UIViewController+Alerts.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/6/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    public func showAlert2(message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true)
    }
    
}
