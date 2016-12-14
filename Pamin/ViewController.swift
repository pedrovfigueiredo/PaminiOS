//
//  ViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventosTableView: UITableView!
    var events : [Event] = []
    let api = PaminAPI()
    
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
        
        
        api.popularArrayDeEvents { (events) in
            self.events = events
            self.eventosTableView.reloadData()
        }
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        api.popularArrayDeEvents { (events) in
            self.events = events
            self.eventosTableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaEvento") as! CelulaEvento
        
        let event = self.events[indexPath.row]
        cell.labelTitulo.text = event.what
        cell.labelCategoria.text = event.category_name
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

