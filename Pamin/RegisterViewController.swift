//
//  RegisterViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo on 17/01/17.
//  Copyright © 2017 Lavid. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftOverlays

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nomeLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var senhaLabel: UITextField!
    @IBOutlet weak var repitaSenhaLabel: UITextField!
    @IBOutlet weak var cadastrarButton: UIButton!
    @IBOutlet weak var voltarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cadastrarButton.layer.cornerRadius = 15.0
        voltarButton.layer.cornerRadius = 15.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if !(PaminAPI().isInternetAvailable()){
            self.displayAlert(title: "Erro de conexão", message: "Sem conexão com internet. Conecte-se e tente novamente.")
        }
        let mensagemAlerta = checkFields()
        
        if mensagemAlerta == ""{
            
            SwiftOverlays.showBlockingWaitOverlayWithText("Cadastrando...")
            PaminAPI().userSignUp(nome: nomeLabel.text!, email: emailLabel.text!, password: senhaLabel.text!, completion: { (response) in
                switch (response.result) {
                case .success(let data):
                    if self.isValid(data: JSON(data)){
                        SwiftOverlays.removeAllBlockingOverlays()
                        
                        //Ir para tela de login
                        let alertController = UIAlertController(title: "Sucesso", message: "Usuário cadastrado com sucesso.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            self.performSegue(withIdentifier: "backtoLogin", sender: nil)
                        })
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        SwiftOverlays.removeAllBlockingOverlays()
                        let errors = self.getErrors(data: JSON(data))
                        self.displayAlert(title: "Erro", message: String(describing: errors))
                        
                    }
                case .failure(let error):
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.displayAlert(title: "Erro", message: "Erro ao registrar usuário. Por favor, tente novamente mais tarde. Código do erro: \(error)")
                
                }
            })
            
        }else{
            self.displayAlert(title: "Erro", message: mensagemAlerta)
        }
    }
    
    func getErrors(data: JSON) -> [String]{
        if let errors = data["errors"].arrayObject {
            return errors as! [String]
        }
        return []
    }
    
    // Se houve um campo "user" no json de resposta, é válido.
    func isValid(data: JSON) -> Bool{
        
        if data["user"].dictionary != nil {
            return true
        }
        return false
    }
    
    func displayAlert(title: String, message : String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        controller.addAction(action)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func checkFields() -> String{
        
        var mensagemAlerta : String = ""
        
        if (nomeLabel.text?.characters.count)! <= 4 {
            mensagemAlerta.append("O nome tem que ter mais de 4 caracteres.")
            nomeLabel.text = ""
        }
        
        if !(isValidEmail(testStr: emailLabel.text!)) {
            if mensagemAlerta != ""{mensagemAlerta.append("\n")}
            mensagemAlerta.append("Email inválido.")
            emailLabel.text = ""
        }
        
        if (senhaLabel.text?.characters.count)! < 8 {
            if mensagemAlerta != ""{mensagemAlerta.append("\n")}
            mensagemAlerta.append("A senha tem que ter pelo menos 8 caracteres.")
            senhaLabel.text = ""
            repitaSenhaLabel.text = ""
        }else{
            if senhaLabel.text != repitaSenhaLabel.text {
                if mensagemAlerta != ""{mensagemAlerta.append("\n")}
                mensagemAlerta.append("As senhas não coincidem.")
                senhaLabel.text = ""
                repitaSenhaLabel.text = ""
            }
        }
        return mensagemAlerta
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func backtoLogin(_ sender: Any) {
        performSegue(withIdentifier: "backtoLogin", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

