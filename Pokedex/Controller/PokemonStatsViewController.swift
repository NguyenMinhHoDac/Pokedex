//
//  PokemonStatsViewController.swift
//  Pokedex
//
//  Created by Finofantashi on 08/08/2022.
//

import UIKit
import Alamofire
import ALProgressView

class PokemonStatsViewController: UIViewController{
    
    @IBOutlet weak var scrollBar: UIScrollView!
    @IBOutlet weak var statCollection: UICollectionView!
    @IBOutlet weak var typeCollection: UICollectionView!
    @IBOutlet weak var abilityTable: UITableView!
    @IBOutlet weak var eggGroup0: UILabel!
    @IBOutlet weak var eggGroup1: UILabel!
    @IBOutlet weak var hatchStep: UILabel!
    @IBOutlet weak var hatchCycle: UILabel!
    @IBOutlet weak var habitat: UILabel!
    @IBOutlet weak var generation: UILabel!
    @IBOutlet weak var captureRate: ALProgressRing!
    @IBOutlet weak var captureRateLabel: UILabel!
    @IBOutlet weak var imgDefault: UIImageView!
    @IBOutlet weak var imgShiny: UIImageView!
    
    var stats : [String] = ["HP", "ATK", "DEF", "SATK", "SDEF", "SPD"]
    var double = Set<String>()
    var half = Set<String>()
    var no = Set<String>()
    var abilityText = [[FlavorText]]()
    
    var pokemon : Pokemon?
    var speciesProp : SpeciesProp?
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GUI()
        SetData()
        scrollBar.delegate = self
        statCollection.delegate = self
        statCollection.dataSource = self
        typeCollection.delegate = self
        typeCollection.dataSource = self
        abilityTable.delegate = self
        abilityTable.dataSource = self
    }
    
    func SetData()
    {
        fetchType(url: pokemon!.types[0].pokeType.url)
        if (pokemon!.types.count == 2)
        {
            fetchType(url: pokemon!.types[1].pokeType.url)
        }
        for i in stride(from: 0, to: pokemon!.abilities.count , by: 1)
        {
            fetchAbility(url: pokemon!.abilities[i].ability.url, index: i)
        }
    }
    
    func GUI() {
        scrollBar.layer.cornerRadius = 48
        abilityTable.rowHeight = UITableView.automaticDimension
        abilityTable.tableFooterView = UIView(frame: .zero)
        eggGroup0.text = speciesProp!.eggGroups[0].name.capitalized
        eggGroup1.text = speciesProp!.eggGroups.count > 1 ? speciesProp!.eggGroups[1].name.capitalized : ""
        hatchCycle.text = String(speciesProp!.hatch) + " Cycles"
        habitat.text = speciesProp!.habitat.name.capitalized
        generation.text = speciesProp!.generation.name.capitalized
        captureRateLabel.text = String(speciesProp!.captureRate) + "%"
        captureRate.lineWidth = 5
        captureRate.setProgress(Float(speciesProp!.captureRate)/100, animated: true)
        captureRate.startColor = UIColor(red: 128.0/255.0, green: 182.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        captureRate.endColor = UIColor(red: 128.0/255.0, green: 182.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        loadingImg(imageView: imgDefault, url: pokemon!.sprites.other.home.imgDefault)
        loadingImg(imageView: imgShiny, url: pokemon!.sprites.other.home.imgShiny)        
    }

    func fetchType(url: String) {
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
    
    func fetchAbility(url: String, index: Int) {
        AF.request(url)
            .validate()
            .responseDecodable(of: TextEntries.self)
        {
            (response) in guard let items = response.value else { return }
            self.abilityText.append(items.all)
            self.abilityTable.reloadData()
        }
    }
    
    func loadingImg(imageView: UIImageView,url: String) {
        let url = URL(string: url)
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "ic_pokemon_placeholder"), options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25))
        ])
    }
}


//Collection
extension PokemonStatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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


//Table
extension PokemonStatsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (pokemon?.abilities.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AbilityTableViewCell", for: indexPath) as! AbilityTableViewCell
        cell.name.text = pokemon?.abilities[indexPath.row].ability.name.capitalized
        if (abilityText.count == pokemon!.abilities.count)
        {
            cell.script.text = abilityText[indexPath.row].first(where: { $0.language.name == "en" && $0.version.name == "x-y"})?.flavorText.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
        }
        cell.iconHidden.isHidden = !(pokemon?.abilities[indexPath.row].isHidden)!
        return cell
    }
    
    
}

extension PokemonStatsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            if let parentVC = parent?.parent as? PokemonDetailViewController {
                if delta > 0,
                   topViewUnwrappedHeight > parentVC.topViewHeightConstraintRange?.lowerBound ?? 0,
                   scrollView.contentOffset.y > 0 {
                    
                    
                    dragDirection = .Up
                    innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                    scrollView.contentOffset.y -= delta
                }
                
                
                if delta < 0,
                   topViewUnwrappedHeight < parentVC.topViewHeightConstraintRange?.upperBound ?? 0,
                   scrollView.contentOffset.y < 0 {
                    
                    dragDirection = .Down
                    innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                    scrollView.contentOffset.y -= delta
                }
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
    }
}
