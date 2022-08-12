//
//  EvolutionViewController.swift
//  Pokedex
//
//  Created by SMin on 11/08/2022.
//

import UIKit
import Alamofire

class EvolutionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var pokemon : Pokemon?
    var speciesProp : SpeciesProp?
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    var evolutionChain = [Evolution]()
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchEvolutionChain(url: speciesProp!.evolutionChain.url)
    }
    
    func loadingImg(imageView: UIImageView,url: String) {
        let url = URL(string: url)
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "ic_pokemon_placeholder"), options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25))
        ])
    }
    
    func fetchEvolutionChain(url: String)
    {
        AF.request(url)
            .validate()
            .responseDecodable(of: Chain.self)
        {
            (response) in guard let item = response.value else { return }
            var chain = item.chain
            while (chain.evolvesTo.count != 0)
            {
                self.evolutionChain.append(chain)
                chain = chain.evolvesTo[0]
            }
            self.evolutionChain.append(chain)
            for i in self.evolutionChain
            {
                self.fetchImg(name: i.species.name)
            }
            self.fetchSpecies(name: self.evolutionChain.last!.species.name)
            self.tableView.reloadData()
        }
    }
    
    func fetchImg(name: String)
    {
        AF.request("https://pokeapi.co/api/v2/pokemon/\(name)")
        .validate()
        .responseDecodable(of: Pokemon.self)
        {
            (response) in guard let pokemon = response.value else { return }
//            print(pokemon)
//            self.pokemons.insert(pokemon, at: self.pokemons.count)
            
            self.pokemons.append(pokemon)
            self.pokemons = self.pokemons.sorted { $0.id < $1.id }
            self.tableView.reloadData()
        }
    }
    
    func fetchSpecies(name: String) {
        AF.request("https://pokeapi.co/api/v2/pokemon-species/\(name)")
            .validate()
            .responseDecodable(of: SpeciesProp.self)
        {
            (response) in guard let items = response.value else { return }
            if(items.varieties.count > 1)
            {
                if (items.varieties.first(where: { $0.pokemon.name.contains("mega") || $0.pokemon.name.contains("gmax")}) != nil)
                {
                    self.fetchImg(name: items.varieties.first(where: { $0.pokemon.name.contains("mega") || $0.pokemon.name.contains("gmax")})!.pokemon.name)
                }
                else
                {
                    self.evolutionChain.removeLast()
                }
            }
            self.tableView.reloadData()
        }
    }
}


//Table
extension EvolutionViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        evolutionChain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvolutionTableViewCell", for: indexPath) as! EvolutionTableViewCell
        if (indexPath.row != evolutionChain.count - 1)
        {
//            cell.name1.text = evolutionChain[indexPath.row].species.name.capitalized
//            cell.name2.text = evolutionChain[indexPath.row].evolvesTo[0].species.name.capitalized
            if (pokemons.count > evolutionChain.count)
            {
                cell.name1.text = pokemons[indexPath.row].name.capitalized
                cell.name2.text = pokemons[indexPath.row + 1].name.capitalized
                loadingImg(imageView: cell.img1, url: pokemons[indexPath.row].sprites.other.official.img)
                loadingImg(imageView: cell.img2, url: pokemons[indexPath.row + 1].sprites.other.official.img)
            }
            cell.level.text = (evolutionChain[indexPath.row].evolvesTo[0].evolutionDetails[0].level != nil)
                ? ("Lv." + String(evolutionChain[indexPath.row].evolvesTo[0].evolutionDetails[0].level!))
                : (evolutionChain[indexPath.row].evolvesTo[0].evolutionDetails[0].item != nil)
                    ? (evolutionChain[indexPath.row].evolvesTo[0].evolutionDetails[0].item!.name.capitalized.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil))
                    : ("Happiness " + String(evolutionChain[indexPath.row].evolvesTo[0].evolutionDetails[0].happiness!))
        }
        else
        {
            if (pokemons.count > evolutionChain.count)
            {
                cell.name1.text = pokemons[indexPath.row].name.capitalized
                cell.name2.text = pokemons[indexPath.row + 1].name.capitalized.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                loadingImg(imageView: cell.img1, url: pokemons[indexPath.row].sprites.other.official.img)
                loadingImg(imageView: cell.img2, url: pokemons[indexPath.row + 1].sprites.other.official.img)
                cell.level.text = (pokemons[indexPath.row + 1].name.contains("mega"))
                    ? "Mega Stone"
                    : (pokemons[indexPath.row + 1].name.contains("gmax")) ? "Gmax" : ""
            }
        }
        return cell
    }
}


extension EvolutionViewController: UIScrollViewDelegate {
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

