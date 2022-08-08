//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by SMin on 04/08/2022.
//

import UIKit
import Alamofire

class PokemonDetailViewController: UIViewController{

    @IBOutlet weak var scrollBar: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var typeTag: UIImageView!
    @IBOutlet weak var script: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var statCollection: UICollectionView!
    @IBOutlet weak var typeCollection: UICollectionView!
    
    var stats : [String] = ["HP", "ATK", "DEF", "SATK", "SDEF", "SPD"]
    var double = Set<String>()
    var half = Set<String>()
    var no = Set<String>()
    
    var pokemon : Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GUI()
        fetchType(url: pokemon!.types[0].pokeType.url)
        if (pokemon!.types.count == 2)
        {
            fetchType(url: pokemon!.types[1].pokeType.url)
        }
        statCollection.delegate = self
        statCollection.dataSource = self
        typeCollection.delegate = self
        typeCollection.dataSource = self
   
        // Do any additional setup after loading the view.
    }
    
    func GUI()
    {
        setGradientBackground()
        scrollBar.layer.cornerRadius = 48
        contentView.layer.cornerRadius = 48
        loadingImg(url: pokemon!.sprites.other.official.img)
        typeTag.image = UIImage(named: pokemon!.types[0].pokeType.name + "Tag")
        name.text = pokemon!.name
        segmentControl.backgroundColor = UIColor.white
        segmentControl.selectedSegmentTintColor = UIColor.systemCyan
    
    

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
    }
    
    func setGradientBackground()
    {
        let colorLeft =  UIColor(red: 85.0/255.0, green: 194.0/255.0, blue: 251.0/255.0, alpha: 1.0).cgColor
        let colorRight = UIColor(red: 145.0/255.0, green: 235.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func loadingImg(url: String) {
            let url = URL(string: url)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url!) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        print("Error fetching the image!")
                    } else {
                        self.img.image = UIImage(data: data!)
                    }
                }
            }
            dataTask.resume()
        }

//    static func create() -> PokemonDetailViewController {
//        let vc = PokemonDetailViewController()
//        vc.title = "pokemon"
//
//        vc.headerView = Head()
//        vc.viewControllers = [
////            FirstTabViewController(style: .plain),
////            SecondTabViewController(style: .plain)
//        ]
//
//        return vc
//    }
    func fetchType(url: String)
    {
        AF.request(url)
        .validate()
        .responseDecodable(of: DamageRelations.self)
        {
            (response) in guard let items = response.value else { return }
            for i in items.all.doubleDamageFrom
            {
                self.double.insert(i.name)
            }
            for i in items.all.halfDamageFrom
            {
                self.half.insert(i.name)
            }
            for i in items.all.noDamegeFrom
            {
                self.no.insert(i.name)
            }
            self.typeCollection.reloadData()
        }
    }
}

extension PokemonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView == statCollection)
        {
            return stats.count
        }
        else
        {
            return type.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if(collectionView == statCollection)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCollectionViewCell", for: indexPath) as! StatCollectionViewCell
            cell.statName.text = stats[indexPath.row]
            cell.baseStat.text = String(format: "%03d",(pokemon?.stats[indexPath.row].baseStat)!)
            cell.statPercent.progress = Float((pokemon?.stats[indexPath.row].baseStat)!) / 150

            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
            cell.icon.image = UIImage(named: type[indexPath.row]!)
            cell.value.text = "1x"
            if (self.double.contains(type[indexPath.row]!))
                { cell.value.text = "2x"}
            if (self.half.contains(type[indexPath.row]!))
                { cell.value.text = "1/2x"}
            if (self.no.contains(type[indexPath.row]!))
                { cell.value.text = "0x"}
            return cell
        }
    }
}

