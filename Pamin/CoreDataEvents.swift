//
//  CoreDataEvents.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 16/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataEvents {
    
    let indexKey = "INDICE_EVENTOS"
    
    // Recuperar contexto
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func salvarEventosEmBD(eventos: [Event]){
        
        var indiceUltimoEvento: Int
        
        if UserDefaults.standard.object(forKey: indexKey) != nil{
            
            indiceUltimoEvento = UserDefaults.standard.object(forKey: indexKey) as! Int
            
            for evento in eventos {
                if evento.event_id > indiceUltimoEvento{
                    self.salvarEvento(evento: evento)
                }
            }
        }else{
            for evento in eventos {
                self.salvarEvento(evento: evento)
            }
            UserDefaults.standard.set(eventos.last?.event_id, forKey: indexKey)
        }
        
        do{
            let context = getContext()
            try context.save()
        }catch {
            print("Erro ao salvar eventos no Banco.")
        }
    }
    
    // Salvar evento
    func salvarEvento(evento: Event){
        let eventoCoreData = Evento(context: self.getContext())
        
        eventoCoreData.category_id = Int16(evento.category_id)
        eventoCoreData.category_name = evento.category_name
        eventoCoreData.created_at = evento.created_at
        eventoCoreData.description_event = evento.description
        eventoCoreData.end_date = evento.end_date
        eventoCoreData.event_id = Int16(evento.event_id)
        eventoCoreData.latitude = evento.latitude
        eventoCoreData.longitude = evento.longitude
        eventoCoreData.pictures = evento.pictures
        eventoCoreData.price = evento.price
        eventoCoreData.promotor = evento.promotor
        eventoCoreData.promotor_contact = evento.promotor_contact
        eventoCoreData.start_date = evento.start_date
        eventoCoreData.updated_at = evento.updated_at
        eventoCoreData.what = evento.what
        eventoCoreData.where_ = evento.where_event
    }
    
    // Recuperar todos os Eventos
    func recuperarTodosEventos() -> [Event]{
        
        let context = self.getContext()
        do{
            var eventos : [Event] = []
            let eventosCoreData = try context.fetch(Evento.fetchRequest()) as! [Evento]
            for eventoCoredata in eventosCoreData {
                let evento = Event(eventoCoreData: eventoCoredata)
                eventos.append(evento)
            }
            return eventos
        }catch{
            print("Erro ao recuperar eventos do banco de dados")
        }
        return []
    }
    
}
