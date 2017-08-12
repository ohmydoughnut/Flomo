//
//  ItemTableViewCell.swift
//  Timer
//
//  Created by Delano Kamp on 11/08/2017.
//  Copyright © 2017 Delano Kamp. All rights reserved.
//

import UIKit

//
class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
