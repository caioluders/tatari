//
//  VotoTableViewCell.swift
//  Tatari
//
//  Created by Déborah Mesquita on 27/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class VotoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var btVote: UIButton!
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
