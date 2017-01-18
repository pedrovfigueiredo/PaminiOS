//
//  ViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var eventosTableView: UITableView!
    
    
    
    var events : [Event] = []
    let api = PaminAPI()
    let coreDataEvents = CoreDataEvents()
    var filtro: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            self.eventosTableView.reloadData()
        }
        
        //GAMBIARRA PARA SLIDE MENU FUNCIONAR
        UserDefaults.standard.set(0, forKey: "telaOrigem")
    }
    
    // ESCONDENDO ROW SE TIVER FILTRO APLICADO
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.filtro == 0 {
            return 300
        }else if events[indexPath.row].category_id != self.filtro{
            return 0
        }
    
        return 300
    }
    
    // ATUALIZAR DADOS COM BANCO ONLINE (GESTO DE ARRASTAR TABLEVIEW PARA BAIXO)
    
    func refresh(_ refreshControl: UIRefreshControl) {
        atualizarDados()
        refreshControl.endRefreshing()
    }
    
    func atualizarDados(){
        api.popularArrayDeEvents { (events) in
            self.coreDataEvents.salvarEventosEmBD(eventos: events)
            self.events = self.coreDataEvents.recuperarTodosEventos()
            self.eventosTableView.reloadData()
        }
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
        cell.imagemEventoCelula.image = event.recuperarImagemEvento(evento: event)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

