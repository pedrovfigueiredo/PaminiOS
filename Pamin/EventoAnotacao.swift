//
//  EventoAnotacao.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 14/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import MapKit

class EventoAnotacao: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var evento: Event
    var title: String?
    var subtitle: String?
    
    init(coordenadas: CLLocationCoordinate2D, evento: Event, title: String, subtitle: String) {
        self.coordinate = coordenadas
        self.evento = evento
        self.title = title
        self.subtitle = subtitle
    }
    
    @objc func getImageAnotacao()  -> UIImage {
        
        switch self.evento.category_id {
        case 1:
            return #imageLiteral(resourceName: "Pessoas")
        case 2:
            return #imageLiteral(resourceName: "Lugares")
        case 3:
            return #imageLiteral(resourceName: "Celebra_es_s")
        case 4:
            return #imageLiteral(resourceName: "Saberes")
        case 5:
            return #imageLiteral(resourceName: "Formas_de_Express_o_")
        case 6:
            return #imageLiteral(resourceName: "Objetos")
        default: break
        }
        
        // Se for default, retorna imagem default
        
        return #imageLiteral(resourceName: "tudo")
    }
    
}
