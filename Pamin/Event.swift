 //
 //  Message.swift
 //  Pamin
 //
 //  Created by Pedro Figueirêdo and Luan Lima on 12/13/16.
 //  Copyright © 2016 Luan Lima. All rights reserved.
 //
 
 import UIKit
 import Foundation
 
 typealias JSONDictionary = [String: AnyObject]
 
 
 class Event{
    
    ///Event Informations
    private var _event_id: Int!
    private var _what: String!
    private var _where_event: String!
    private var _latitude: String!
    private var _longitude: String!
    private var _promotor: String!
    private var _promotor_contact: String!
    private var _pictures: [String]!
    private var _description: String!
    private var _price: String!
    
    
    ///Date Informations
    private var _start_date: String!
    private var _end_date: String!
    private var _created_at: String!
    private var _updated_at: String!
    
    
    /// Category Informations
    private var _category_id: Int?
    private var _category_name: String!
    
    
    ///user informations
    private var _user_id: Int!
    private var _user_email: String!
    private var _user_name: String!
    
    
    init (data: JSONDictionary){
        
        ///Event informations from Json
        if let event_id = data["id"] as? Int {
            self._event_id = event_id;
        } else {
            self._event_id = 0
        }
        
        
        if let description = data["description"] as? String {
            self._description = description;
        } else {
            _description = ""
        }
        
        
        if let what = data["what"] as? String {
            self._what = what;
        } else {
            _what = ""
        }
        
        
        if let where_event = data["where"] as? String {
            self._where_event = where_event;
        } else {
            self._where_event = ""
        }
        
        
        if let latitude = data["latitude"] as? String {
            self._latitude = latitude;
        } else {
            self._latitude = ""
        }
        
        
        if let longitude = data["longitude"] as? String {
            self._longitude = longitude;
        } else {
            self._longitude = ""
        }
        
        
        if let promotor = data["promotor"] as? String {
            self._promotor = promotor;
        } else {
            self._promotor = ""
        }
        
        
        if let promotor_contact = data["promotor_contact"] as? String {
            self._promotor_contact = promotor_contact;
        } else {
            self._promotor_contact = ""
        }
        
        
        if let pictures = data["pictures"] as? [String] {
            self._pictures = [];
            for picture in pictures{
                if !picture.isEmpty{
                    self._pictures.append(picture);
                }
            }
        } else {
            self._pictures = [];
        }
        
        
        if let price = data["price"] as? String {
            self._price = price;
        } else {
            self._price = ""
        }
        
        
        /// Date informations from Json
        if let start_date = data["start_date"] as? String {
            self._start_date = start_date
        } else {
            _start_date = ""
        }
        
        
        if let end_date = data["end_date"] as? String {
            self._end_date = end_date
        } else {
            self._end_date = ""
        }
        
        
        if let created_at = data["created_at"] as? String {
            self._created_at = created_at
        } else {
            _created_at = ""
        }
        
        
        if let updated_at = data["updated_at"] as? String {
            self._updated_at = updated_at
        } else {
            _updated_at = ""
        }
        
        
        /// Category informations from Json
        if let category = data["category"] {
            if let category_id = category["id"] as? Int {
                self._category_id = category_id
            } else {
                _category_id = nil
            }
            if let category_name = category["name"] as? String {
                self._category_name = category_name
            } else {
                _category_name = ""
            }
        }
        
        
        /// User informations from Json
        if let user = data["user"] {
            if let user_id = user["id"] as? Int {
                self._user_id = user_id
            } else {
                _user_id = 0
            }
            if let user_email = user["email"] as? String {
                self._user_email = user_email
            } else {
                _user_email = ""
            }
            if let user_name = user["name"] as? String {
                self._user_name = user_name
            } else {
                _user_name = ""
            }
        }
 
        
    }
    
    init(eventoCoreData: Evento) {
        
        self._category_id = Int(eventoCoreData.category_id)
        self._category_name = eventoCoreData.category_name!
        self._created_at = eventoCoreData.created_at
        self._description = eventoCoreData.description_event
        self._end_date = eventoCoreData.end_date
        self._event_id = Int(eventoCoreData.event_id)
        self._latitude = eventoCoreData.latitude
        self._longitude = eventoCoreData.longitude
        self._pictures = eventoCoreData.pictures as! [String]!
        self._price = eventoCoreData.price
        self._promotor = eventoCoreData.promotor
        self._promotor_contact = eventoCoreData.promotor_contact
        self._start_date = eventoCoreData.start_date
        self._updated_at = eventoCoreData.updated_at
        self._what = eventoCoreData.what
        self._where_event = eventoCoreData.where_
        self._user_id = Int(eventoCoreData.user_id)
        self._user_name = eventoCoreData.user_name ?? ""
        self._user_email = eventoCoreData.user_email ?? ""
    }
    
    
    init(){
        self._event_id = 0
        self._description = ""
        self._what = ""
        self._where_event = ""
        self._latitude = ""
        self._longitude = ""
        self._promotor = ""
        self._promotor_contact = ""
        self._pictures = []
        self._price = ""
        self._start_date = ""
        self._end_date = ""
        self._created_at = ""
        self._updated_at = ""
        self._category_id = nil
        self._category_name = ""
        self._user_email = ""
        self._user_name = ""
        self._user_id = nil
    }
    
    var event_id: Int {
        get {
            return _event_id
        } set(id) {
            self._event_id = id
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
    
    
    var where_event: String {
        get {
            return self._where_event
        } set(where_event) {
            self._where_event = where_event
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
    
    
    var pictures: [String] {
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
    
    
    var category_id: Int {
        get {
            return self._category_id!
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
    
    
    var user_id: Int {
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
            "id": _category_id as AnyObject,
            "name": _category_name as AnyObject
        ]
        
        
        user = [
            "id": _user_id as AnyObject,
            "email": _user_email as AnyObject,
            "name": _user_name as AnyObject
        ]
        
        
        json = [
            "id": _event_id as AnyObject,
            "what": _what as AnyObject,
            "where": _where_event as AnyObject,
            "start_date": _start_date as AnyObject,
            "end_date": _end_date as AnyObject,
            "price": _price as AnyObject,
            "promotor": _promotor as AnyObject,
            "promotor_contact": _promotor_contact as AnyObject,
            "latitude": _latitude as AnyObject,
            "longitude": _longitude as AnyObject,
            "description": _description as AnyObject,
            "pictures": _pictures as AnyObject,
            "category": category as AnyObject,
            "user": user as AnyObject
        ]
        
        
        return json
    }
    
    func recuperarImagemPadraoEvento(evento: Event) -> UIImage{
        
            // RETORNA IMAGEM PADRÃO DA CATEGORIA
            switch evento.category_id {
            case 1:
                return #imageLiteral(resourceName: "pessoasL")
            case 2:
                return #imageLiteral(resourceName: "lugaresL")
            case 3:
                return #imageLiteral(resourceName: "celebracaoL")
            case 4:
                return #imageLiteral(resourceName: "saberesL")
            case 5:
                return #imageLiteral(resourceName: "expressaoL")
            case 6:
                return #imageLiteral(resourceName: "objlarge")
            default:
                return #imageLiteral(resourceName: "tudo")
            }
    }
    
 }
