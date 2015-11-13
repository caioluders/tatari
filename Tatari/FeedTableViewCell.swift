//
//  FeedTableViewCell.swift
//  Tatari
//
//  Created by Déborah Mesquita on 27/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtBody: UITextView!
    @IBOutlet weak var imgMessageTagType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
