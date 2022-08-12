//
//  AbilityTableViewCell.swift
//  Pokedex
//
//  Created by SMin on 09/08/2022.
//

import UIKit

class AbilityTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var script: UILabel!
    @IBOutlet weak var iconHidden: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
