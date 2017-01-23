//
//  CoreDataEvents.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 16/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataEvents {
    
    let indexKey = NSLocalizedString("chaveCoreDataLastIndex", comment: "")
    
    // Recuperar contexto
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func haUsuarioLogado() -> Bool {
        do{
            let context = self.getContext()
            let usuariosCoreData: [Usuario] = try context.fetch(Usuario.fetchRequest()) as! [Usuario]
            if usuariosCoreData.count != 0 {
                return true
            }
        }catch{
            fatalError("Erro ao recuperar usuário do CoreData")
        }
        return false
    }
    
    func salvarUsuarioEmBD(usuario: User){
        
        // TESTE PARA VER SE EXISTE USUÁRIO LOGADO
        
        if self.haUsuarioLogado() == true{self.deletarUsuarioCoreData()}
        
        let usuarioCoreData = Usuario(context: self.getContext())
        
        usuarioCoreData.user_email = usuario.user_email
        usuarioCoreData.user_name = usuario.user_name
        usuarioCoreData.user_id = Int16(usuario.user_id)
        usuarioCoreData.user_token = usuario.user_token
        
        do{
            let context = self.getContext()
            try context.save()
        }catch{
            fatalError("Erro ao salvar Usuário no CoreData")
        }
    }
    
    func salvarEventosEmBD(eventos: [Event], forceupdate: Bool){
        
        var indiceUltimoEvento: Int
        
        var maiorIndice : Int = 0
        for evento in eventos{
            if evento.event_id > maiorIndice{maiorIndice = evento.event_id}
        }
        
        if UserDefaults.standard.object(forKey: indexKey) != nil && forceupdate == false{
            
            indiceUltimoEvento = UserDefaults.standard.object(forKey: indexKey) as! Int
            
            for evento in eventos {
                if evento.event_id > indiceUltimoEvento{
                    self.salvarEvento(evento: evento, salvarContexto: false)
                }
            }
            
            if maiorIndice > indiceUltimoEvento{
                UserDefaults.standard.set(eventos.last?.event_id, forKey: indexKey)
            }
        }else{
            self.limparEventosCoreData()
            for evento in eventos {
                self.salvarEvento(evento: evento, salvarContexto: false)
            }
            UserDefaults.standard.set(maiorIndice, forKey: indexKey)
        }
        
        do{
            let context = getContext()
            try context.save()
        }catch {
            fatalError("Erro ao salvar Eventos no CoreData")
        }
    }
    
    // Salvar evento
    func salvarEvento(evento: Event, salvarContexto: Bool){
        let eventoCoreData = Evento(context: self.getContext())
        
        eventoCoreData.category_id = Int16(evento.category_id)
        eventoCoreData.category_name = evento.category_name
        eventoCoreData.created_at = evento.created_at
        eventoCoreData.description_event = evento.description
        eventoCoreData.end_date = evento.end_date
        eventoCoreData.event_id = Int16(evento.event_id)
        eventoCoreData.latitude = evento.latitude
        eventoCoreData.longitude = evento.longitude
        eventoCoreData.pictures = evento.pictures as NSObject
        eventoCoreData.price = evento.price
        eventoCoreData.promotor = evento.promotor
        eventoCoreData.promotor_contact = evento.promotor_contact
        eventoCoreData.start_date = evento.start_date
        eventoCoreData.updated_at = evento.updated_at
        eventoCoreData.what = evento.what
        eventoCoreData.where_ = evento.where_event
        eventoCoreData.user_name = evento.user_name
        eventoCoreData.user_id = Int16(evento.user_id)
        eventoCoreData.user_email = evento.user_email
        
        if salvarContexto == true {
            do{
                let context = getContext()
                try context.save()
            }catch {
                fatalError("Erro ao salvar Evento no CoreData")
            }
        }
    }
    
    func limparEventosCoreData() {
        let context = self.getContext()
        do{
            let eventosCoreData = try context.fetch(Evento.fetchRequest())
            for eventoCoreData in eventosCoreData {
                context.delete(eventoCoreData as! NSManagedObject)
            }
        }catch{
            fatalError("Erro ao limpar Coredata ou Coredata vazio")
        }
    }
    
    func deletarUsuarioCoreData(){
        let context = self.getContext()
        do{
            let usuariosCoreData = try context.fetch(Usuario.fetchRequest())
            for usuarioCoreData in usuariosCoreData {
                context.delete(usuarioCoreData as! NSManagedObject)
            }
        }catch{
            fatalError("Erro ao recuperar usuário no CoreData")
        }
    }
    
    func recuperarUsuarioLogado() -> User{
        let context = self.getContext()
        do{
            let usuarioCoreData = try context.fetch(Usuario.fetchRequest()) as! [Usuario]
            let usuario = User(usuario: usuarioCoreData.last!)
            return usuario
        }catch{
            fatalError("Erro ao recuperar usuário logado do banco de dados")
        }
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
            fatalError("Erro ao recuperar eventos do banco de dados")
        }
        return []
    }
    
}
