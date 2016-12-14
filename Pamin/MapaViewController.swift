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
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurarGerenciadorLocalizacao()
        mapa.delegate = self
        
        let api = PaminAPI()
        api.popularArrayDeEvents { (events) in
            self.eventos = events
            self.marcarAnotacoes()
        }
    }
    
    func marcarAnotacoes(){
        
        for evento in eventos{
            
            let anotacao = MKPointAnnotation()
            anotacao.coordinate.latitude = Double(evento.latitude)!
            anotacao.coordinate.longitude = Double(evento.longitude)!
            anotacao.title = evento.what
            anotacao.subtitle = evento.category_name
            
            self.mapa.addAnnotation(anotacao)
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
        
        let deltaLatitude = 0.05
        let deltaLongitude = 0.05
        
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
        // Dispose of any resources that can be recreated.
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
