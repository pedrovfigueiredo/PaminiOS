 //
 //  Message.swift
 //  pamin
 //
 //  Created by Pedro Figueirêdo and Luan Lima on 12/19/16.
 //  Copyright © 2016 Luan Lima. All rights reserved.
 //

import UIKit

class MenuController: UITableViewController {
    
    var filtro : Int = 0
    var telaOrigem : Int!
    var usuarioLogado = User()
    
    // Imagens
    @IBOutlet weak var imagemTudo: UIImageView!
    @IBOutlet weak var imagemPessoas: UIImageView!
    @IBOutlet weak var imagemLugares: UIImageView!
    @IBOutlet weak var imagemCeleb: UIImageView!
    @IBOutlet weak var imagemSaberes: UIImageView!
    @IBOutlet weak var imagemExpress: UIImageView!
    @IBOutlet weak var imagemObjetos: UIImageView!
    
    
    // Informações do Usuário
    @IBOutlet weak var nomeUsuario: UILabel!
    @IBOutlet weak var emailUsuario: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usuarioLogado = CoreDataEvents().recuperarUsuarioLogado()
        self.nomeUsuario.text = usuarioLogado.user_name
        self.emailUsuario.text = usuarioLogado.user_email
        
        arrendondarImagens()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "telaOrigem") != nil {
            self.telaOrigem = UserDefaults.standard.object(forKey: "telaOrigem") as! Int
        }
    }
    
    func arrendondarImagens(){
        imagemTudo.layer.cornerRadius = imagemTudo.frame.size.width / 2;
        imagemTudo.clipsToBounds = true
        imagemPessoas.layer.cornerRadius = imagemPessoas.frame.size.width / 2;
        imagemPessoas.clipsToBounds = true
        imagemCeleb.layer.cornerRadius = imagemCeleb.frame.size.width / 2;
        imagemCeleb.clipsToBounds = true
        imagemLugares.layer.cornerRadius = imagemLugares.frame.size.width / 2;
        imagemLugares.clipsToBounds = true
        imagemSaberes.layer.cornerRadius = imagemSaberes.frame.size.width / 2;
        imagemSaberes.clipsToBounds = true
        imagemExpress.layer.cornerRadius = imagemExpress.frame.size.width / 2;
        imagemExpress.clipsToBounds = true
        imagemObjetos.layer.cornerRadius = imagemObjetos.frame.size.width / 2;
        imagemObjetos.clipsToBounds = true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1{
            switch indexPath.row {
            case 0: // TUDO
                filtro = 0
            case 1: // PESSOAS
                filtro = 1
            case 2: // LUGARES
                filtro = 2
            case 3: // CELEBRAÇÕES
                filtro = 3
            case 4: // SABERES
                filtro = 4
            case 5: // FORMAS DE EXPRESSÃO
                filtro = 5
            case 6: // OBJETOS
                filtro = 6
            default:
                filtro = 0
            }
            performSegue(withIdentifier: "voltarTabController", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "voltarTabController"{
            switch self.telaOrigem {
            case 0:
                let destino = segue.destination as! CustomTabController
                destino.indiceTela = 0
                destino.filtro = self.filtro
            case 1:
                let destino = segue.destination as! CustomTabController
                destino.indiceTela = 1
                destino.filtro = self.filtro
            default:
                print("Algo deu errado")
            }
        }

    }

    @IBAction func logOutUser(_ sender: Any) {
        
        PaminAPI().userLogout(usuario: self.usuarioLogado)
        
        CoreDataEvents().deletarUsuarioCoreData()
        performSegue(withIdentifier: "segueLogOut", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
