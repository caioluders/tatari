//
//  personTableViewCell.swift
//  Tatari
//
//  Created by Déborah Mesquita on 06/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class personTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPessoa: UIImageView!
    @IBOutlet weak var lblCurtir: UILabel!
    @IBOutlet weak var lblDesafiar: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var btCurtir: UIButton!
    @IBOutlet weak var btFacebook: UIButton!
    @IBOutlet weak var btDesafiar: UIButton!
    @IBOutlet weak var lblNome: UILabel!
    
    var fbId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btFacebookPressed(sender: UIButton) {
        print(self.fbId)
    }
    
    @IBAction func btDesafiarPressed(sender: UIButton) {
        print("desafiar")
        let searchVC = SearchController()
        
        let alertController = UIAlertController(title: "Enviar desafio", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let challenge1 = UIAlertAction(title: "Dê uma bebida pro mais gato(a)", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge1)
        
        let challenge2 = UIAlertAction(title: "Vá ao bar se quiser um beijo", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge2)
        
        let challenge3 = UIAlertAction(title: "Vire uma dose e grite 'AI PAPAI'!", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge3)
        
        let challenge4 = UIAlertAction(title: "Mostre que vocé é top nos falsetes", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge4)
        
        let challenge5 = UIAlertAction(title: "Desce até o chão rodando", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge5)
        
        searchVC.presentVC(alertController)
        
    }
    
    @IBAction func btCurtirPressed(sender: AnyObject) {
        print("curtir")
    }

}
