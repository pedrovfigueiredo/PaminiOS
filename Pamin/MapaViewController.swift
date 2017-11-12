//
//  MapaViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @objc var gerenciadorLocalizacao = CLLocationManager()
    var eventos : [Event] = []
    @objc var isFirstCall: Bool = true
    let coreDataEvents = CoreDataEvents()
    @objc var filtro : Int = 0
    
    @IBOutlet weak var menuMapButton: UIBarButtonItem!
    
    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var centralizarUsuarioButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurarGerenciadorLocalizacao()
        mapa.delegate = self
        
        if revealViewController() != nil {
            menuMapButton.target = revealViewController()
            menuMapButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rightViewRevealWidth = 150
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.tabBarController != nil{
            let tabBarController = self.tabBarController as! CustomTabController
            self.filtro = tabBarController.filtro
        }
        
        if UserDefaults.standard.object(forKey: "regiaoAtualMapa") != nil {
            let arrayInfoRegiao = UserDefaults.standard.object(forKey: "regiaoAtualMapa") as! NSArray
            
            self.Centralizar(latitude: arrayInfoRegiao[0] as! CLLocationDegrees, longitude: arrayInfoRegiao[1] as! CLLocationDegrees, deltaLatitude: arrayInfoRegiao[2] as! CLLocationDegrees, deltaLongitude: arrayInfoRegiao[3] as! CLLocationDegrees, animated: false)
        }
        
        self.eventos = coreDataEvents.recuperarTodosEventos()
        self.marcarAnotacoes()
        
        //GAMBIARRA PARA SLIDE MENU FUNCIONAR
        UserDefaults.standard.set(1, forKey: "telaOrigem")
    }
    
    @objc func marcarAnotacoes(){
        
        for evento in eventos{
            
            if evento.category_id == self.filtro || self.filtro == 0{
                let coordenadas = CLLocationCoordinate2D(latitude: Double(evento.latitude)!, longitude: Double(evento.longitude)!)
                let anotacao = EventoAnotacao(coordenadas: coordenadas, evento: evento, title: evento.what, subtitle: evento.category_name)
                
                self.mapa.addAnnotation(anotacao)
            }
        }
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if isFirstCall == true{
            
            if UserDefaults.standard.object(forKey: "regiaoAtualMapa") == nil {
                let localizacaoUsuario = locations.last!
                
                self.Centralizar(latitude: localizacaoUsuario.coordinate.latitude, longitude: localizacaoUsuario.coordinate.longitude, deltaLatitude: 0.008, deltaLongitude: 0.008, animated: true)
            }
            
            self.isFirstCall = false
            
        }
        
        //GRAVANDO REGIÃO ATUAL
        let regiao = mapa.region
        let arrayInfoRegiao : NSArray = [regiao.center.latitude, regiao.center.longitude, regiao.span.latitudeDelta, regiao.span.longitudeDelta]
        UserDefaults.standard.set(arrayInfoRegiao, forKey: "regiaoAtualMapa")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Esconde botão de centralizar usuário quando o mapa já está centralizado
        let centroMapa = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        let localizacaoUsuario = gerenciadorLocalizacao.location ?? CLLocation()
        let distancia = localizacaoUsuario.distance(from: centroMapa) as Double
        if  distancia < 10 {
            self.centralizarUsuarioButton.isHidden = true
        }else{
            self.centralizarUsuarioButton.isHidden = false
        }
    }
    
    
    @IBAction func centralizarUsuario(_ sender: Any) {
        // Recupera coordenadas do usuário
        let location = gerenciadorLocalizacao.location
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        self.Centralizar(latitude: latitude!, longitude: longitude!, deltaLatitude: 0.008, deltaLongitude: 0.008, animated: true)
    }

    
    @objc func Centralizar(latitude: CLLocationDegrees, longitude: CLLocationDegrees, deltaLatitude: CLLocationDegrees, deltaLongitude: CLLocationDegrees, animated: Bool){
        
        let localizacao = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let zoom = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        
        let region = MKCoordinateRegion(center: localizacao, span: zoom)
        mapa.setRegion(region, animated: animated)
    }

    
    @objc func configurarGerenciadorLocalizacao(){
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

    @IBAction func addButton(_ sender: Any) {
        let userIsLogged = CoreDataEvents().haUsuarioLogado()
        if (userIsLogged) {
            performSegue(withIdentifier: "segueAdd", sender: nil)
        } else {
            let alert = UIAlertController(title: "Atenção", message: "É necessário entrar para registrar um novo evento.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Entrar", style: .cancel, handler: { action in
                self.performSegue(withIdentifier: "segueLogIn", sender: nil)
            }))
        }
    }
    
}
