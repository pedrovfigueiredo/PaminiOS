//
//  LoginViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit
import UITextField_Navigation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usuarioTextField = UITextField()
        let senhaTextField = UITextField()
        usuarioTextField.nextTextField = senhaTextField
        
        assert(senhaTextField == usuarioTextField.nextTextField)
        assert(usuarioTextField == senhaTextField.previousTextField)
        
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
        if !(api.isInternetAvailable()){
            EZLoadingActivity.hide()
            self.displayAlert(title: "Erro de conexão", message: "Sem conexão com internet. Tente novamente mais tarde.")
        }
        
        api.userLogin(email: self.usuarioTextField.text!, password: self.senhaTextField.text!) { (user) in
            if user.user_token == "" { //Failure
                EZLoadingActivity.hide()
                self.displayAlert(title: "Erro de Autenticação", message: "Usuário e/ou senha incorretos. Tente novamente.")
                
            }else{ // Success
                
                // GUARDA INFO DO USUARIO LOGADO
                CoreDataEvents().salvarUsuarioEmBD(usuario: user)
                EZLoadingActivity.hide(true, animated: true)
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

extension ViewController: UITextFieldNavigationDelegate { // explicitly protocol conforming declaration
    
    func textFieldNavigationDidTapPreviousButton(_ textField: UITextField) {
        textField.previousTextField?.becomeFirstResponder()
    }
    
    func textFieldNavigationDidTapNextButton(_ textField: UITextField) {
        textField.nextTextField?.becomeFirstResponder()
    }
    
    func textFieldNavigationDidTapDoneButton(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
