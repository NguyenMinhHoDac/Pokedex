//
//  EvolutionTableViewCell.swift
//  Pokedex
//
//  Created by SMin on 11/08/2022.
//

import UIKit

class EvolutionTableViewCell: UITableViewCell {
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var level: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
