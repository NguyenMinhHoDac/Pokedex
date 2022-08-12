//
//  MoveTableViewCell.swift
//  Pokedex
//
//  Created by SMin on 11/08/2022.
//

import UIKit

class MoveTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var type0: UIImageView!
    @IBOutlet weak var type1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
