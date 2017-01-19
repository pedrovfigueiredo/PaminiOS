//
//  User.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 20/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class User{
    
    ///user informations
    private var _user_id: Int!
    private var _user_email: String!
    private var _user_name: String!
    private var _user_token: String!
    
    init() {
        self._user_email = ""
        self._user_id = 0
        self._user_name = ""
        self._user_token = ""
    }
    
    init(user_id: Int, user_name: String, user_email: String, user_token: String) {
        self._user_id = user_id
        self._user_name = user_name
        self._user_email = user_email
        self._user_token = user_token
    }
    
    init(usuario: Usuario){
        self._user_id = Int(usuario.user_id)
        self._user_name = usuario.user_name!
        self._user_email = usuario.user_email
        self._user_token = usuario.user_token!
    }
    
    init(data: JSON) {
        /// User informations from Json
        if let user = data["user"].dictionary {
            if let user_id = user["id"]?.int {
                self._user_id = user_id
            } else {
                _user_id = 0
            }
            if let user_email = user["email"]?.string {
                self._user_email = user_email
            } else {
                _user_email = ""
            }
            if let user_name = user["name"]?.string {
                self._user_name = user_name
            } else {
                _user_name = ""
            }
        }
        
        // Authentication Headers from Json
        if let authHeaders = data["authentication_headers"].dictionary {
            if let user_token = authHeaders["user_token"]?.string{
                self._user_token = user_token
            }
        }
    
        
    }
    
    var user_id: Int {
        get {
            return self._user_id
        }set {
            self._user_id = user_id
        }
    }
    
    var user_name: String {
        get {
            return self._user_name
        }set {
            self._user_name = user_name
        }
    }
    
    var user_email: String {
        get {
            return self._user_email
        }set {
            self._user_email = user_email
        }
    }
    
    var user_token: String {
        get {
            return self._user_token
        }set {
            self._user_token = user_token
        }
    }
    
}
