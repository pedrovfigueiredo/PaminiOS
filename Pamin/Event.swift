 //
 //  Message.swift
 //  pamin
 //
 //  Created by Luan Lima on 12/13/16.
 //  Copyright © 2016 Luan Lima. All rights reserved.
 //
 
 import UIKit
 import Foundation
 
 typealias JSONDictionary = [String: AnyObject]
 
 
 class Event {
    
    ///Event Informations
    private var _id: String!
    private var _what: String!
    private var _where_id: String!
    private var _latitude: String!
    private var _longitude: String!
    private var _promotor: String!
    private var _promotor_contact: String!
    private var _pictures: String!
    private var _description: String!
    private var _price: String!
    
    
    ///Date Informations
    private var _start_date: String!
    private var _end_date: String!
    private var _created_at: String!
    private var _updated_at: String!
    
    
    /// Category Informations
    private var _category_id: String!
    private var _category_name: String!
    
    
    ///user informations
    private var _user_id: String!
    private var _user_email: String!
    private var _user_name: String!
    
    
    init (data: JSONDictionary){
        
        ///Event informations from Json
        if let id = data["id"] as? String {
            self._id = id;
        } else {
            self._id = "none"
        }
        
        
        if let description = data["description"] as? String {
            self._description = description;
        } else {
            _description = "none"
        }
        
        
        if let what = data["what"] as? String {
            self._what = what;
        } else {
            _what = "none"
        }
        
        
        if let where_id = data["where"] as? String {
            self._where_id = where_id;
        } else {
            self._where_id = "none"
        }
        
        
        if let latitude = data["latitude"] as? String {
            self._latitude = latitude;
        } else {
            self._latitude = "none"
        }
        
        
        if let longitude = data["longitude"] as? String {
            self._longitude = longitude;
        } else {
            self._longitude = "none"
        }
        
        
        if let promotor = data["promotor"] as? String {
            self._promotor = promotor;
        } else {
            self._promotor = "none"
        }
        
        
        if let promotor_contact = data["promotor_contact"] as? String {
            self._promotor_contact = promotor_contact;
        } else {
            self._promotor_contact = "none"
        }
        
        
        if let pictures = data["pictures"] as? String {
            self._pictures = pictures;
        } else {
            self._pictures = "none"
        }
        
        
        if let price = data["price"] as? String {
            self._price = price;
        } else {
            self._price = "none"
        }
        
        
        /// Date informations from Json
        if let start_date = data["start_date"] as? String {
            self._start_date = start_date
        } else {
            _start_date = "none"
        }
        
        
        if let end_date = data["end_date"] as? String {
            self._end_date = end_date
        } else {
            self._end_date = "none"
        }
        
        
        if let created_at = data["created_at"] as? String {
            self._created_at = created_at
        } else {
            _created_at = "none"
        }
        
        
        if let updated_at = data["updated_at"] as? String {
            self._updated_at = updated_at
        } else {
            _updated_at = "none"
        }
        
        
        /// Category informations from Json
        if let category = data["category"] {
            if let category_id = category["id"] as? String {
                self._category_id = category_id
            } else {
                _category_id = "none"
            }
            if let category_name = category["name"] as? String {
                self._category_name = category_name
            } else {
                _category_name = "none"
            }
        }
        
        
        /// User informations from Json
        if let user = data["user"] {
            if let user_id = user["id"] as? String {
                self._category_id = user_id
            } else {
                _user_id = "none"
            }
            if let user_email = user["email"] as? String {
                self._user_email = user_email
            } else {
                _user_email = "none"
            }
            if let user_name = user["name"] as? String {
                self._user_name = user_name
            } else {
                _user_name = "none"
            }
        }
        
    }
    
    
    init(){
        self.id = ""
        self.description = ""
        self.what = ""
        self.where_id = ""
        self.latitude = ""
        self.longitude = ""
        self.promotor = ""
        self.promotor_contact = ""
        self.pictures = ""
        self.price = ""
        self.start_date = ""
        self.end_date = ""
        self.created_at = ""
        self.updated_at = ""
        self.category_id = ""
        self.category_name = ""
    }
    
    var id: String {
        get {
            return _id
        } set(id) {
            self._id = id
        }
    }
    
    
    var description: String {
        get {
            return _description
        } set(description) {
            self._description = description
        }
    }
    
    
    var what: String {
        get {
            return self._what
        } set(what){
            self._what = what
        }
    }
    
    
    var where_id: String {
        get {
            return self._where_id
        } set(where_id) {
            self._where_id = where_id
        }
    }
    
    
    var latitude: String {
        get {
            return self._latitude
        } set(latitude) {
            self._latitude = latitude
        }
    }
    
    var longitude: String {
        get {
            return _longitude
        } set(longitude) {
            self._longitude = longitude
        }
    }
    
    
    var promotor: String {
        get {
            return self._promotor
        } set(promotor) {
            self._promotor = promotor
        }
    }
    
    
    var promotor_contact: String {
        get {
            return self._promotor_contact
        } set(promotor_contact) {
            self._promotor_contact = promotor_contact
        }
    }
    
    
    var pictures: String {
        get {
            return self._pictures
        } set(pictures) {
            self._pictures = pictures
        }
    }
    
    var price: String {
        get {
            return self._price
        } set(price) {
            self._price = price
        }
    }
    
    
    var start_date: String {
        get {
            return self._start_date
        } set(start_date) {
            self._start_date = start_date
        }
    }
    
    
    var end_date: String {
        get {
            return self._end_date
        } set(end_date) {
            self._end_date = end_date
        }
    }
    
    
    var created_at: String {
        get {
            return self._created_at
        } set(created_at) {
            self._created_at = created_at
        }
    }
    
    
    var updated_at: String {
        get {
            return self._updated_at
        } set(updated_at) {
            self._updated_at = updated_at
        }
    }
    
    
    var category_id: String {
        get {
            return self._category_id
        } set(category_id) {
            self._category_id = category_id
        }
    }
    
    
    var category_name: String {
        get {
            return self._category_name
        } set(category_name) {
            self._category_name = category_name
        }
    }
    
    
    var user_id: String {
        get {
            return self._user_id
        } set(user_id) {
            self._user_id = user_id
        }
    }
    
    
    var user_email: String {
        get {
            return self._user_email
        } set(user_email) {
            self._user_email = user_email
        }
    }
    
    
    var user_name: String {
        get {
            return self._user_name
        } set(user_name) {
            self._user_name = user_name
        }
    }
    
    
    func toJson() -> JSONDictionary{
        var json = JSONDictionary()
        var category = JSONDictionary()
        var user = JSONDictionary()
        
        
        category = [
            "category_id": category_id as AnyObject,
            "category_name": category_name as AnyObject
        ]
        
        
        user = [
            "user_id": user_id as AnyObject,
            "user_email": user_email as AnyObject,
            "user_name": user_name as AnyObject
        ]
        
        
        json = [
            "id": id as AnyObject,
            "what": what as AnyObject,
            "where": where_id as AnyObject,
            "start_date": start_date as AnyObject,
            "end_date":end_date as AnyObject,
            "price": price as AnyObject,
            "promotor": promotor as AnyObject,
            "promotor_contact": promotor_contact as AnyObject,
            "latitude": latitude as AnyObject,
            "longitude": longitude as AnyObject,
            "description": description as AnyObject,
            "pictures": pictures as AnyObject,
            "category": category as AnyObject,
            "user": user as AnyObject
        ]
        
        
        return json
    }
 }

