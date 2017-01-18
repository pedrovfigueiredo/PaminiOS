//
//  LoginViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit

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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginUser(_ sender: Any) {
        
        EZLoadingActivity.show("Entrando...", disableUI: true)
        
        let api = PaminAPI()
        api.userLogin(email: self.usuarioTextField.text!, password: self.senhaTextField.text!) { (user) in
            if user.user_token == "" { //Failure
                
                let alertController = UIAlertController(title: "Erro de Autenticação", message: "Usuário e/ou senha incorretos. Tente novamente.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(alertAction)
                EZLoadingActivity.hide()
                self.present(alertController, animated: true, completion: nil)
                
            }else{ // Success
                
                // GUARDA INFO DO USUARIO LOGADO
                CoreDataEvents().salvarUsuarioEmBD(usuario: user)
                EZLoadingActivity.hide(true, animated: true)
                // VAI PARA PRÓXIMA TELA
                self.performSegue(withIdentifier: "pastLogin", sender: nil)
                
            }
            
        }
        
    }
}
