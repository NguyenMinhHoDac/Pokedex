//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by SMin on 01/08/2022.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var lbPokeName: UILabel!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var imgPoke: UIImageView!
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        self.selectedBackgroundView = setGradientBackground()
    }

    func setGradientBackground() -> UIView{
        let bgColorView = UIView()
        let colorTop =  UIColor(red: 145.0/255.0, green: 235.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 104.0/255.0, green: 186.0/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.5, 1]
        gradientLayer.frame = self.bounds
        bgColorView.layer.insertSublayer(gradientLayer, at:0)
        return bgColorView
    }
    
    func loadingImg(url: String) {
            let url = URL(string: url)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url!) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        print("Error fetching the image!")
                    } else {
                        self.imgPoke.image = UIImage(data: data!)
                    }
                }
            }
            dataTask.resume()
        }

    func setData(poke: Pokemon) {
        lbId.text = "#" + String(format: "%03d", poke.id)
        imgPoke.image = nil
        loadingImg(url: poke.sprites.other.official.img)
        lbPokeName.text = poke.name
        type1.image = nil
        type2.image = nil
        type1.image = UIImage(named: poke.types[0].pokeType.name)
        if (poke.types.count == 2)
        {
            type2.image = UIImage(named: poke.types[1].pokeType.name)
        }
    }
}
