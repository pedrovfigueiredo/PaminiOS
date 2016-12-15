//
//  MapaViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var gerenciadorLocalizacao = CLLocationManager()
    var eventos : [Event] = []
    var isFirstCall: Bool = true
    let api = PaminAPI()
    
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurarGerenciadorLocalizacao()
        mapa.delegate = self
        
    }
    
    func marcarAnotacoes(){
        
        for evento in eventos{
            
            let coordenadas = CLLocationCoordinate2D(latitude: Double(evento.latitude)!, longitude: Double(evento.longitude)!)
            let anotacao = EventoAnotacao(coordenadas: coordenadas, evento: evento, title: evento.what, subtitle: evento.category_name)
            
            self.mapa.addAnnotation(anotacao)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation { // mostrar usuario
            
        }else{ // mostrar evento
            let eventoAnotacao  = (annotation as! EventoAnotacao)
            anotacaoView.image = eventoAnotacao.getImageAnotacao()
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        anotacaoView.canShowCallout = true
        
        // Adicionando botão
        let btn = UIButton(type: .detailDisclosure)
        anotacaoView.rightCalloutAccessoryView = btn
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let anotacao = view.annotation as! EventoAnotacao
            let evento = anotacao.evento
            performSegue(withIdentifier: "detalhesEventoSegue", sender: evento)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesEventoSegue"{
            let viewControllerDestino = segue.destination as! DetalhesEventoViewController
            viewControllerDestino.evento = sender as! Event
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        self.eventos.removeAll()
        
        api.popularArrayDeEvents { (events) in
            self.eventos = events
            self.marcarAnotacoes()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if isFirstCall == true{
            
            let localizacaoUsuario = locations.last!
            
            self.Centralizar(latitude: localizacaoUsuario.coordinate.latitude, longitude: localizacaoUsuario.coordinate.longitude)
            
            self.isFirstCall = false
            
        }
    }
    
    @IBAction func centralizarUsuario(_ sender: Any) {
        // Recupera coordenadas do usuário
        let location = gerenciadorLocalizacao.location
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        self.Centralizar(latitude: latitude!, longitude: longitude!)
    }

    
    func Centralizar(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let deltaLatitude = 0.03
        let deltaLongitude = 0.03
        
        let localizacao = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let zoom = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        
        let region = MKCoordinateRegion(center: localizacao, span: zoom)
        mapa.setRegion(region, animated: true)
    }

    
    func configurarGerenciadorLocalizacao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertaController = UIAlertController(title: "Permissão de Localização", message: "Necessária localização para funcionamento do mapa", preferredStyle: .alert)
            
            let alertaConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default, handler: {(alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let alertaCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertaController.addAction(alertaConfiguracoes)
            alertaController.addAction(alertaCancelar)
            
            present(alertaController, animated: true, completion: nil)
        }
    }


}
