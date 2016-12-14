//
//  PaminAPI.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import Foundation
import Alamofire

class PaminAPI {
    
    var events : [Event] = []
    
    func popularArrayDeEvents(completion: @escaping ([Event])->()) {
        
        guard let URL = NSURL(string: "http://pamin.lavid.ufpb.br:3333/api/registers.json")
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
                    print(resposta.result)
                    completion(self.events)
                }
            
        }
    }
    
    func getEvents() -> [Event]{
        return self.events
    }
    
    /*
    func completion(response:[Event]) {
        self.events = response
    }
 */
}


