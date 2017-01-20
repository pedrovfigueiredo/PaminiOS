//
//  PaminAPI.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

class PaminAPI {
    
    var events = [Event]()
    let PAMINAPI : String = "http://pamin.lavid.ufpb.br:80/api/"
    let PAMINEVENTOS: String = "registers/"
    let PAMINLOGIN: String = "auth/sign_in"
    let PAMINLOGOUT: String = "auth/sign_out"
    let PAMINSIGNUP: String = "users"
    
    
    func popularArrayDeEvents(completion: @escaping ([Event])->()) {
        self.events.removeAll()
        guard let URL = NSURL(string: PAMINAPI + PAMINEVENTOS)
            else{
                print("Não foi possível criar a URL")
                return
        }
        
        let Requisicao = URLRequest(url: URL as URL)
        
        Alamofire.request(Requisicao)
            .responseJSON { (resposta) in
                
                if let json = resposta.result.value as? [JSONDictionary] {
                    for item in json {
                        let entry = Event(data: item)
                        self.events.append(entry)
                    }
                    completion(self.events)
                }
        }
    }
    
    func recuperarEventoBD(event_id: Int, completion: @escaping (Event)->()){
        let URL = PAMINAPI + PAMINEVENTOS + String(event_id)
        
        Alamofire.request(URL)
            .responseJSON { (response) in
                if let json = response.result.value as? JSONDictionary {
                    let event = Event(data: json)
                    completion(event)
                }
        }
    }

    
    func userLogout(usuario: User){
        let URL = PAMINAPI + PAMINLOGOUT
        
        //let parameters : Parameters = ["token": usuario.user_token, "id": usuario.user_id]
        
        Alamofire.request(URL)
            .responseJSON(completionHandler: { (response) in
                print("Logout successful")
                print(response.response?.statusCode as Any)
            })
    }
    
    
    
    func cadastrarNovoEvento(evento: Event, completion: @escaping (DataResponse<Data>)->()){
        let URL = PAMINAPI + PAMINEVENTOS
        let eventJSON = eventToJSON(event: evento)
        let headers = self.getUserHeader(user: CoreDataEvents().recuperarUsuarioLogado())
        
     
        Alamofire.request(URL, method: .post, parameters: eventJSON, encoding: JSONEncoding.default, headers: headers)
            .responseData { (response) in
                completion(response)
            }
     }
    
    
    func userSignUp(nome: String, email: String, password: String, completion: @escaping (DataResponse<Any>)->()){
        
        let userJSON = userSignUpToJSON(nome: nome, email: email, password: password)
        let URL = PAMINAPI + PAMINSIGNUP
        
        Alamofire.request(URL, method: .post, parameters: userJSON, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                completion(response)
        }
    }
    
    
    func userLogin(email:String, password: String, completion: @escaping (User)->()){
        
        let userJSON = userLogInToJSON(email: email, password: password)
        let URL = PAMINAPI + PAMINLOGIN
        
        Alamofire.request(URL, method: .post , parameters: userJSON, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response) in
                var user = User()
                switch response.result {
                case .success(let data):
                    user = User(data: JSON(data))
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                completion(user)
            })
    }
    
    func getUserHeader(user: User) -> HTTPHeaders {
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "X-User-Email" : user.user_email,
            "X-User-Token" : user.user_token
        ]
        return headers
    }
    
    // Quando samuel implementar os outros parâmetros, lembrar de atualizar
    func eventToJSON(event: Event) -> Parameters{
        
        
        let eventoJSON = [
            //"id": event.event_id,
            "what": event.what,
            "where": event.where_event,
            "start_date": event.start_date,
            "end_date": event.end_date,
            "price": event.price,
            "promotor": event.promotor,
            "promotor_contact": event.promotor_contact,
            "latitude": Double(event.latitude)!,
            "longitude": Double(event.longitude)!,
            "description": event.description,
            "pictures": ["http://res.cloudinary.com/demo/image/upload/sample.jpg","http://res.samuel.com"],
            "category_id": event.category_id
            ] as Parameters
        
        return eventoJSON
    }
    
    
    func userSignUpToJSON(nome: String, email: String, password: String) -> Parameters{
        
        let userJSON = [
            "name": nome,
            "email": email,
            "password": password
        ] as Parameters
        
        return userJSON
    }
    
    
    func userLogInToJSON(email: String, password: String) -> Parameters{
        
        let userJSON = [
            "api_user": [
                "email": email, "password": password
            ]
            ] as Parameters
        
        return userJSON
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}


