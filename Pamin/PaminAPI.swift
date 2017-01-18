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

class PaminAPI {
    
    var events = [Event]()
    let PAMINAPI : String = "http://pamin.lavid.ufpb.br:3333/api/"
    let PAMINEVENTOS: String = "registers.json"
    let PAMINLOGIN: String = "auth/sign_in"
    let PAMINLOGOUT: String = "auth/sign_out"
    
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
        
        //print("Evento: \(eventJSON), Headers: \(headers)")
     
        Alamofire.request(URL, method: .post, parameters: eventJSON, encoding: JSONEncoding.default, headers: headers)
            .responseData { (response) in
                completion(response)
            }
     }
    
    
    
    func userLogin(email:String, password: String, completion: @escaping (User)->()){
        
        let userJSON = userToJSON(email: email, password: password)
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
            //"pictures": event.pictures,
            "category_id": event.category_id
            ] as Parameters
        
        return eventoJSON
    }
    
    
    func userToJSON(email: String, password: String) -> Parameters{
        
        let userJSON = [
            "api_user": [
                "email": email, "password": password
            ]
            ] as Parameters
        
        return userJSON
    }
}


