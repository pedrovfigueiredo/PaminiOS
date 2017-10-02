//
//  ViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var eventosTableView: UITableView!
    
    
    var events : [Event] = []
    let api = PaminAPI()
    let coreDataEvents = CoreDataEvents()
    var gerenciadorLocalizacao = CLLocationManager()
    var userlocation = CLLocation()
    var filtro: Int = 0
    var isUserLocationProcessed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurarGerenciadorLocalizacao()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            eventosTableView.refreshControl = refreshControl
        } else {
            eventosTableView.backgroundView = refreshControl
        }
        
        eventosTableView.delegate = self
        eventosTableView.dataSource = self
        
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rightViewRevealWidth = 150
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if self.tabBarController != nil{
            let tabBarController = self.tabBarController as! CustomTabController
            self.filtro = tabBarController.filtro
        }
        
        // SÓ CONSULTAR BANCO DE DADOS ONLINE SE NÃO HOUVER NADA GRAVADO EM CORE DATA
        let events : [Event] = self.coreDataEvents.recuperarTodosEventos()
        if  events.count == 0 {
            self.atualizarDados()
        }else{
            self.events = events
            if UserDefaults.standard.object(forKey: "ultimaLocalizacaoUsuario") != nil {
                
                let ultimaLocalizacaoUsuario = UserDefaults.standard.object(forKey: "ultimaLocalizacaoUsuario") as! NSArray
                self.userlocation = CLLocation(latitude: ultimaLocalizacaoUsuario[0] as! CLLocationDegrees, longitude: ultimaLocalizacaoUsuario[1] as! CLLocationDegrees)
                self.ordenarTableView()
                self.isUserLocationProcessed = true
            }else{
                self.isUserLocationProcessed = false
                self.gerenciadorLocalizacao.requestLocation()
            }
            
            self.reloadDataWithAnimation()
        }
    
        
        //GAMBIARRA PARA SLIDE MENU FUNCIONAR
        UserDefaults.standard.set(0, forKey: "telaOrigem")
    }
    
    // ESCONDENDO ROW SE TIVER FILTRO APLICADO
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.filtro == 0 {
            return 180
        }else if events[indexPath.row].category_id != self.filtro{
            return 0
        }
    
        return 180
    }
    
    // ATUALIZAR DADOS COM BANCO ONLINE (GESTO DE ARRASTAR TABLEVIEW PARA BAIXO)
    
    func refresh(_ refreshControl: UIRefreshControl) {
        
        if !(api.isInternetAvailable()){
            let controller = UIAlertController(title: "Erro de conexão", message: "Sem conexão com internet. Tente novamente mais tarde.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                refreshControl.endRefreshing()
            }
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
            
        }else{
            atualizarDados()
            refreshControl.endRefreshing()
        }
    }
    
    func atualizarDados(){
        api.popularArrayDeEvents { (events) in
            self.coreDataEvents.salvarEventosEmBD(eventos: events)
            self.events = self.coreDataEvents.recuperarTodosEventos()
            self.isUserLocationProcessed = false
            self.gerenciadorLocalizacao.requestLocation()
            self.reloadDataWithAnimation()
        }
    }
    
    func containSameElements(events1 : [Event], events2 : [Event]) -> Bool{
        
        if events1.count != events2.count{return false}
        
        var index : Int = 0
        for event1 in events1{
            if event1.description != events2[index].description{
                return false
            }
            index = index + 1
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detalhesEventoSegue", sender: self.events[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesEventoSegue"{
            
            let viewControllerDestino = segue.destination as! DetalhesEventoViewController
            viewControllerDestino.evento = sender as! Event!
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaEvento") as! CelulaEvento
        
        let event = self.events[indexPath.row]
        cell.labelTitulo.text = event.what
        cell.labelEndereco.text = event.where_event
        cell.titleCategoria.text = event.category_name
        
        if !event.pictures.isEmpty{
            let url = URL(string: event.pictures.first!)
            
            cell.imagemEventoCelula.af_setImage(withURL: url!, placeholderImage: event.recuperarImagemPadraoEvento(evento: event), filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: nil)
            
        }else{
            cell.imagemEventoCelula.image = event.recuperarImagemPadraoEvento(evento: event)
        }
        

        var distancia = self.distanciaUsuarioEvento(evento: event)
        distancia = (distancia/1000)
        distancia = Double(round(100*distancia)/100)
        
        cell.cellBG.layer.cornerRadius = 7.0
        cell.labelCategoria.layer.cornerRadius = 5.0
        cell.imagemEventoCelula.layer.cornerRadius = 6.0
        cell.labelCategoria.backgroundColor = self.getColorEvento(evento: event)
    
        cell.distanciaLabel.text = ("\(String(describing: distancia)) km")
        if isUserLocationProcessed == true {
            cell.distanciaLabel.isHidden = false
            cell.pinLabel.isHidden = false
            cell.spinnerDistancia.stopAnimating()
        }else{
            cell.spinnerDistancia.startAnimating()
            cell.distanciaLabel.isHidden = true
            cell.pinLabel.isHidden = true
        }

        return cell
    }
    
    func getColorEvento(evento: Event)  -> UIColor {
        
        switch evento.category_id {
        case 1:
            return UIColor(red: 47/255, green: 55/255, blue: 136/255, alpha: 1)
        case 2:
            return UIColor(red: 50/255, green: 171/255, blue: 223/255, alpha: 1)
        case 3:
            return UIColor(red: 188/255, green: 33/255, blue: 50/255, alpha: 1)
        case 4:
            return UIColor(red: 186/255, green: 41/255, blue: 139/255, alpha: 1)
        case 5:
            return UIColor(red: 245/255, green: 147/255, blue: 49/255, alpha: 1)
        case 6:
            return UIColor(red: 104/255, green: 186/255, blue: 78/255, alpha: 1)
        default: break
        }
        
        // Se for default, todos serão brancos
        
        return UIColor.white
    }
    
    func distanciaUsuarioEvento(evento: Event) -> Double{
        let location = CLLocation(latitude: Double(evento.latitude)!, longitude: Double(evento.longitude)!)
        return location.distance(from: self.userlocation)
    }
    
    func ordenarTableView(){
        self.events.sort { (evento1, evento2) -> Bool in
            return self.distanciaUsuarioEvento(evento: evento1) < self.distanciaUsuarioEvento(evento: evento2)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userlocation = locations.last!
        let locationArray : NSArray = [self.userlocation.coordinate.latitude, self.userlocation.coordinate.longitude]
        UserDefaults.standard.set(locationArray, forKey: "ultimaLocalizacaoUsuario")
        self.ordenarTableView()
        self.isUserLocationProcessed = true
        self.reloadDataWithAnimation()
    }
    
    
    func configurarGerenciadorLocalizacao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro: \(error)")
    }
    
    func reloadDataWithAnimation(){
        let range = NSMakeRange(0, self.eventosTableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.eventosTableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

