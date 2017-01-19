//
//  DetalhesEventoViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 15/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import MapKit

class DetalhesEventoViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var evento : Event!
    var gerenciadorLocalizacao = CLLocationManager()
    
    
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var whatLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var mapaDescricaoEvento: MKMapView!
    @IBOutlet weak var promotorLabel: UILabel!
    @IBOutlet weak var promotor_contactLabel: UILabel!
    @IBOutlet weak var imagemEvento: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //@IBOutlet weak var bgImagemEvento: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurarGerenciadorLocalizacao()
        mapaDescricaoEvento.delegate = self
        Centralizar(latitude: Double(self.evento.latitude)!, longitude: Double(self.evento.longitude)!)
        self.marcarAnotacao()
        mapaDescricaoEvento.isZoomEnabled = false
        mapaDescricaoEvento.isPitchEnabled = false
        mapaDescricaoEvento.isRotateEnabled = false
        mapaDescricaoEvento.isScrollEnabled = false
        
        //Imagem
        imagemEvento.image = evento.recuperarImagemEvento(evento: evento)
        //bgImagemEvento.image = evento.recuperarImagemEvento(evento: evento)

        
        // Endereço
        whereLabel.text = evento.where_event
        whereLabel.sizeToFit()
        
        //Promotor
        promotorLabel.text = evento.promotor
        promotorLabel.sizeToFit()
        promotor_contactLabel.text = evento.promotor_contact
        
        //Preço
        if evento.price != ""{
            priceLabel.text? = "R$"
            priceLabel.text?.append(evento.price)
        }else{priceLabel.text = ""}
        
        //Data e Hora
        if evento.start_date == "" && evento.end_date == ""{dateLabel.text = ""}
        else{
            let dateFormatterFromEvent = DateFormatter()
            dateFormatterFromEvent.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
            
            let dateFormatterToLabel = DateFormatter()
            dateFormatterToLabel.dateFormat = "dd/MM/yyyy, HH:mm"
            
            if evento.start_date != ""{
                let start_date = dateFormatterFromEvent.date(from: evento.start_date)!
                
                dateLabel.text? = "Começa em "
                dateLabel.text?.append(dateFormatterToLabel.string(from: start_date))
            }
            
            if evento.end_date != ""{
                let end_date = dateFormatterFromEvent.date(from: evento.end_date)!
                
                dateLabel.text?.append("\nTermina em ")
                dateLabel.text?.append(dateFormatterToLabel.string(from: end_date))
            }
        }
        
        //Título
        whatLabel.text = evento.what
        whatLabel.sizeToFit()
        
        //Descrição
        descriptionView.text = evento.description
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            if self.evento.promotor == ""{
                return 0
            }
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Checa-se seção por seção e, se necessário, linha por linha
        switch indexPath.section {
        case 0: // Imagem do Evento
            break
        case 1: // Detalhes
            switch indexPath.row {
            case 0:
                if self.evento.what == ""{return 0}
            case 1:
                if self.evento.price == ""{return 0}
            case 2:
                if self.evento.start_date == "" && self.evento.end_date == ""{return 0}
            default:
                break;
            }
        case 2: // Promotor
            switch indexPath.row {
            case 0:
                if self.evento.promotor == ""{return 0}
            case 1:
                if self.evento.promotor_contact == ""{return 0}
            default:
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        case 3:
            switch indexPath.row {
            case 0:
                if self.evento.where_event == ""{return 0}
            default:
                break;
            }
        default:
            break;
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    

    func marcarAnotacao(){
        
        let coordenadas = CLLocationCoordinate2D(latitude: Double(evento.latitude)!, longitude: Double(evento.longitude)!)
        let anotacao = EventoAnotacao(coordenadas: coordenadas, evento: evento, title: evento.what, subtitle: evento.category_name)
            
        self.mapaDescricaoEvento.addAnnotation(anotacao)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation { // mostrar usuario
            return nil
        }else{ // mostrar evento
            let eventoAnotacao  = (annotation as! EventoAnotacao)
            anotacaoView.image = eventoAnotacao.getImageAnotacao()
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        anotacaoView.canShowCallout = false
        
        return anotacaoView
    }
    
     func configurarGerenciadorLocalizacao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
     func Centralizar(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let deltaLatitude = 0.02
        let deltaLongitude = 0.02
        
        let localizacao = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let zoom = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        
        let region = MKCoordinateRegion(center: localizacao, span: zoom)
        mapaDescricaoEvento.setRegion(region, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     func getColorEvento()  -> UIColor {
     
     switch self.evento.category_id {
     case 7:
     return UIColor(red: 47/255, green: 55/255, blue: 136/255, alpha: 1)
     case 8:
     return UIColor(red: 50/255, green: 171/255, blue: 223/255, alpha: 1)
     case 9:
     return UIColor(red: 188/255, green: 33/255, blue: 50/255, alpha: 1)
     case 10:
     return UIColor(red: 186/255, green: 41/255, blue: 139/255, alpha: 1)
     case 11:
     return UIColor(red: 245/255, green: 147/255, blue: 49/255, alpha: 1)
     case 12:
     return UIColor(red: 104/255, green: 186/255, blue: 78/255, alpha: 1)
     default: break
     }
     
     // Se for default, todos serão brancos
     
     return UIColor.white
     }*/

    
}
