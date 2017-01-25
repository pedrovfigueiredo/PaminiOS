//
//  LoginViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import SwiftOverlays

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entrarButton.layer.cornerRadius = 15.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        self.clearUserDefaults()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func clearUserDefaults(){
        
        if UserDefaults.standard.object(forKey: "regiaoAtualMapa") != nil {
            UserDefaults.standard.removeObject(forKey: "regiaoAtualMapa")
        }
        if UserDefaults.standard.object(forKey: "telaOrigem") != nil{
            UserDefaults.standard.removeObject(forKey: "telaOrigem")
        }
        if UserDefaults.standard.object(forKey: "ultimaLocalizacaoUsuario") != nil {
            UserDefaults.standard.removeObject(forKey: "ultimaLocalizacaoUsuario")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginUser(_ sender: Any) {
        
        SwiftOverlays.showBlockingWaitOverlayWithText("Entrando...")
        
        let api = PaminAPI()
        if !(api.isInternetAvailable()){
            SwiftOverlays.removeAllBlockingOverlays()
            self.displayAlert(title: "Erro de conexão", message: "Sem conexão com internet. Tente novamente mais tarde.")
        }
        
        api.userLogin(email: self.usuarioTextField.text!, password: self.senhaTextField.text!) { (user) in
            if user.user_token == "" { //Failure
                SwiftOverlays.removeAllBlockingOverlays()
                self.displayAlert(title: "Erro de Autenticação", message: "Usuário e/ou senha incorretos. Tente novamente.")
                
            }else{ // Success
                
                // GUARDA INFO DO USUARIO LOGADO
                CoreDataEvents().salvarUsuarioEmBD(usuario: user)
                SwiftOverlays.removeAllBlockingOverlays()
                // VAI PARA PRÓXIMA TELA
                self.performSegue(withIdentifier: "pastLogin", sender: nil)
                
            }
            
        }
        
    }
    
    func displayAlert(title: String, message : String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        controller.addAction(action)
        
        self.present(controller, animated: true, completion: nil)
    }
}
