//
//  AddEventoViewController.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 10/01/17.
//  Copyright © 2017 Lavid. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import SwiftOverlays


class AddEventoViewController : FormViewController, CLLocationManagerDelegate {
    
    var gerenciadorLocalizacao = CLLocationManager()
    let event = Event()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        
        initializeForm()
        self.configurarGerenciadorLocalizacao()
    }
    
    func adicionarEvento(){
        
        SwiftOverlays.showBlockingWaitOverlayWithText("Adicionando...")
        
        if !(PaminAPI().isInternetAvailable()){
            SwiftOverlays.removeAllBlockingOverlays()
            self.displayAlert(title: "Erro de conexão", message: "Sem conexão com internet. Tente novamente mais tarde.")
        }
        
        self.formToEvent { () in
            
            
            PaminAPI().cadastrarNovoEvento(evento: self.event) { (response) in
                switch (response.result) {
                    
                case .success(_):
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.performSegue(withIdentifier: "voltarTelaEventos", sender: nil)
                case .failure(let error):
                    SwiftOverlays.removeAllBlockingOverlays()
                    let controller = UIAlertController(title: "Erro", message: "Erro ao adicionar evento ao servidor. Por favor, tente novamente mais tarde. Código do erro: \(error)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    controller.addAction(action)
                    
                    self.present(controller, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "voltarTelaEventos"{
            UserDefaults.standard.set(0, forKey: "telaOrigem")
        }
    }
    
    // FALTA COLOCAR IMAGEM NO EVENTO
    
    private func formToEvent(completion: @escaping ()->()){
        
        let valuesDictionary = self.form.values()
        
        self.event.what = valuesDictionary["Título"] as! String? ?? ""
        if valuesDictionary["categoria"] as! String? == "Selecionar"{
            self.event.category_name = ""
        }else{
            self.event.category_name = valuesDictionary["categoria"] as! String
        }
        self.event.category_id = self.getIdCategoria(categoria: event.category_name)
        
        self.event.description = valuesDictionary["Descrição"] as? String ?? ""
        
        let locationRow : LocationRow = self.form.rowBy(tag: "Localização")!
        let latitude = locationRow.value?.coordinate.latitude
        let longitude = locationRow.value?.coordinate.longitude
        
        self.event.latitude = String(describing: latitude!)
        self.event.longitude = String(describing: longitude!)
        
        
        if (form.rowBy(tag: "Começa em") as! DateTimeInlineRow).value == nil{
            // Colocar data para nil
            self.event.start_date = ""
            self.event.end_date = ""
            
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
            
            self.event.start_date = dateFormatter.string(from: (form.rowBy(tag: "Começa em") as! DateTimeInlineRow).value!)
            self.event.end_date = dateFormatter.string(from: (form.rowBy(tag: "Termina em") as! DateTimeInlineRow).value!)
        }
        
        if valuesDictionary["É pago?"] as? Bool == true{

            if valuesDictionary["Valor"] as? Double == 0 {
                self.event.price = ""
            }else{
                self.event.price = String(describing: valuesDictionary["Valor"] as! Double)
            }
        }else {
            self.event.price = ""
        }
        
        // Promotor
        self.event.promotor = valuesDictionary["PromotorNome"] as? String ?? ""
        self.event.promotor_contact = valuesDictionary["Contato"] as? String ?? ""
        
        // Usuário
        let user = CoreDataEvents().recuperarUsuarioLogado()
        self.event.user_id = user.user_id
        self.event.user_name = user.user_name
        self.event.user_email = user.user_email
        
        
        self.recuperarInfoPorCoords(latitude: (locationRow.value?.coordinate.latitude)!, longitude: (locationRow.value?.coordinate.longitude)!) { () in
            completion()
        }
        
    }
    
    
    private func initializeForm() {
        
        form =
            
            Section()
            
            <<< TextRow("Título") {
                 $0.title = "Título"
                 $0.add(rule: RuleRequired())
                 $0.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            
            <<< TextAreaRow("Descrição") {
                $0.placeholder = "Descrição"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< ActionSheetRow<String>("categoria") {  // Selecionar Categoria
                $0.title = "Categoria"
                $0.selectorTitle = "Selecione a categoria"
                $0.options = ["Pessoas", "Lugares", "Celebrações", "Saberes", "Formas de Expressão", "Objetos"]
                $0.add(rule: RuleRequired())
                $0.value = ""
                $0.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid  {
                        cell.textLabel?.textColor = .red
                    }
                }
                
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while (row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow){
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            
            
            +++ Section(){
                $0.tag = "Localização"
            }

            
            <<< LocationRow("Localização"){
                $0.title = $0.tag
                let latitude = self.gerenciadorLocalizacao.location?.coordinate.latitude
                let longitude = self.gerenciadorLocalizacao.location?.coordinate.longitude
                $0.value = CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
                
            }
            
            
            
            +++ Section("Imagens"){
                $0.tag = "Imagens"
            }
            
            <<< ImageRow(){
                $0.title = "Selecionar imagens"
            }
            
            
            
            +++ Section("Data") {
                $0.tag = "Data"
                $0.hidden = Condition.function(["categoria"], { form in
                    return ((form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Pessoas" ||
                            (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Objetos" ||
                            (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "")
                })
            }
            
            <<< SwitchRow("Dia inteiro") { // Selecionar Data
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Começa em")
                    let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Termina em")
                    
                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .medium
                        startDate.dateFormatter?.timeStyle = .none
                        endDate.dateFormatter?.dateStyle = .medium
                        endDate.dateFormatter?.timeStyle = .none
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .short
                        startDate.dateFormatter?.timeStyle = .short
                        endDate.dateFormatter?.dateStyle = .short
                        endDate.dateFormatter?.timeStyle = .short
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }
            
            <<< DateTimeInlineRow("Começa em") {
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*24)
                $0.hidden = Condition.function(["categoria"], { form in
                    return ((form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Pessoas" ||
                        (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Objetos" ||
                        (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "")
                })
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Termina em")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "Dia inteiro")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Termina em"){
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*25)
                $0.hidden = Condition.function(["categoria"], { form in
                    return ((form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Pessoas" ||
                        (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Objetos" ||
                        (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "")
                })
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Começa em")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "Dia inteiro")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            
            
            +++ Section("Pagamento"){
                $0.tag = "Pagamento"
                $0.hidden = Condition.function(["categoria"], { form in
                    return ((form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Pessoas" ||
                            (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "Objetos" ||
                            (form.rowBy(tag: "categoria") as! ActionSheetRow).value == "")
                })
            }
            
            <<< SwitchRow("É pago?"){
                $0.title = $0.tag
            }
            
            <<< DecimalRow("Valor"){
                $0.hidden = .function(["É pago?"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "É pago?")
                    return row.value ?? false == false
                })
                $0.useFormatterDuringInput = true
                $0.title = $0.tag
                $0.value = 0.00
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }
            
            
            
            +++ Section("Promotor"){
                $0.tag = "Promotor"
                $0.hidden = Condition.function(["categoria"], { form in
                    return ((form.rowBy(tag: "categoria") as! ActionSheetRow).value == "")
                })
            }
            
            <<< TextRow("PromotorNome") { // Título do Evento
                $0.title = "Nome"
            }
            
            <<< PhoneRow("Contato") { // Título do Evento
                $0.title = "Contato"
            }
        
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Adicionar Evento"
                }
                .onCellSelection { cell, row in
                    let errorsArray = row.section?.form?.validate()
                    if (errorsArray?.isEmpty)! {
                        self.ignoreHiddenRows()
                        self.adicionarEvento()
                    }
                }
        
    }
    
    func ignoreHiddenRows(){
        let date = form.sectionBy(tag: "Data")
        let payment = form.sectionBy(tag: "Pagamento")
        
        if (date?.isHidden)!{
            let start_date = form.rowBy(tag: "Começa em") as! DateTimeInlineRow
            let end_date = form.rowBy(tag: "Termina em") as! DateTimeInlineRow
            start_date.value = nil
            end_date.value = nil
        }
        
        if (payment?.isHidden)!{
            let price = form.rowBy(tag: "Valor") as! DecimalRow
            price.value = nil
        }
    }
    
    
    func recuperarInfoPorCoords(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ()->()){
        
        // Obtendo informações a partir de pontos geográficos
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)){(detalhesLocal, erro) in
            
            if erro == nil {
                
                if let dadosLocal = detalhesLocal?.first {
                    
                    var rua = ""
                    
                    if dadosLocal.thoroughfare != nil{
                        rua = dadosLocal.thoroughfare!
                    }
                    
                    
                    var numero = ""
                    
                    if dadosLocal.subThoroughfare != nil{
                        numero = dadosLocal.subThoroughfare!
                    }
                    
                    var bairro = ""
                    
                    if dadosLocal.subLocality != nil{
                        bairro = dadosLocal.subLocality!
                    }
                    
                    
                    let enderecoCoords = rua + " - " + numero +  " / " + bairro
                    
                    
                    self.event.where_event = enderecoCoords
                    completion()
                    
                    
                }else{
                    let alertaController = UIAlertController(title: "Oops", message: "Erro ao obter informações de endereço", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertaController.addAction(alertAction)
                    
                    self.present(alertaController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    
    
    
    func getIdCategoria(categoria : String) -> Int {
        
        switch categoria {
        case "Pessoas":
            return 1
        case "Lugares":
            return 2
        case "Celebrações":
            return 3
        case "Saberes":
            return 4
        case "Formas de Expressão":
            return 5
        case "Objetos":
            return 6
        default: break
        }
        
        return 0
    }
    
    func configurarGerenciadorLocalizacao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
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
    
    func displayAlert(title: String, message : String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        controller.addAction(action)
        
        self.present(controller, animated: true, completion: nil)
    }
    
}

