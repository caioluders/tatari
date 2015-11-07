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
        searchVC.showChallengePopUp(self.fbId)
        
    }
    
    @IBAction func btCurtirPressed(sender: AnyObject) {
        print("curtir")
    }

}
