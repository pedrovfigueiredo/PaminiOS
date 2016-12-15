//
//  DetalhesEventoViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 15/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit

class DetalhesEventoViewController: UIViewController {
    
    var evento : Event!
    
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var whatLabel: UINavigationItem!
    
    @IBOutlet weak var customBar: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.whatLabel.title = evento.what
        
            // Endereço
            whereLabel.text = evento.where_event
            whereLabel.sizeToFit()
        
            // Descrição do evento
            descriptionView.text = evento.description
        
            self.customBar.backgroundColor = getColorEvento()
            self.navigationBar.barTintColor = getColorEvento()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func voltarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
        
        // Se for default, todos serão pessoas
        
        return UIColor.white
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
