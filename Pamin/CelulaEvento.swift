//
//  CelulaEvento.swift
//  Pamin
//
//  Created by Pedro Figueirêdo and Luan Lima on 13/12/16.
//  Copyright © 2016 Lavid. All rights reserved.
//

import UIKit

class CelulaEvento: UITableViewCell {
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelEndereco: UILabel!
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var imagemEventoCelula: UIImageView!
    @IBOutlet weak var distanciaLabel: UILabel!
    @IBOutlet weak var pinLabel: UIImageView!
    @IBOutlet weak var spinnerDistancia: UIActivityIndicatorView!
    @IBOutlet weak var titleCategoria: UILabel!
    @IBOutlet weak var labelCategoria: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBG.layer.shadowColor = UIColor.lightGray.cgColor
        cellBG.layer.shadowOpacity = 1
        cellBG.layer.shadowOffset = CGSize.zero
        cellBG.layer.shadowRadius = 4
        labelTitulo.sizeToFit()
        labelEndereco.sizeToFit()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
