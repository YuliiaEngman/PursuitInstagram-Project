//
//  AuthentificationSession.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/6/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthentificationSession {
    
    public func createNewuser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
    
    public func signExistingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
}
