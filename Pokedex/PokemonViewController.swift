//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by SMin on 01/08/2022.
//

import UIKit
import Alamofire

class PokemonViewController: UIViewController{
    
    @IBOutlet weak var pokeTableView: UITableView!
    @IBOutlet weak var searchComponent: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet var popUpView: PopUpUIView!
    
    var pokes = [Pokemon] ()
    var searchlist = [Pokemon] ()
    var prePokes : PrePokemons?
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems()
        self.pokeTableView.delegate = self
        self.pokeTableView.dataSource = self
        GUI()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        pokeTableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: pokeTableView)
            if let indexPath = pokeTableView.indexPathForRow(at: touchPoint) {
                popUpView.setData(poke: pokes[indexPath.row])
                animateIn(desiredView: blurView)
                animateIn(desiredView: popUpView)
            }
        }
    }
    func GUI()
    {
        searchComponent.layer.cornerRadius = 18
        blurView.bounds = self.view.bounds
        popUpView.layer.cornerRadius = 25
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowOpacity = 0.5
        popUpView.layer.shadowOffset = CGSize.zero
        popUpView.layer.shadowRadius = 7
        blurView.setOnClickListener {
            self.animateOut(desiredView: self.blurView)
            self.animateOut(desiredView: self.popUpView)
        }
    }
    
    @IBAction func txtSearchChange(_ sender: Any)
    {
        if ( txtSearch.text == nil || txtSearch.text == "" )
        {
            if (pokes.count == offset + 24)
            { return }
            else
            {
                pokes = []
                pokeTableView.reloadData()
                self.offset = 0
                fetchItems()
            }
        }
        else
        {
            searchPokemon(txt: txtSearch.text!)
        }
    }
    
    func searchPokemon(txt: String)
    {
        pokes = []
        pokeTableView.reloadData()
        AF.request("https://pokeapi.co/api/v2/pokemon/?limit=100")
       .validate()
       .responseDecodable(of: PrePokemons.self)
       {
           (response) in guard let items = response.value else { return }
           for i in items.all
           {
               if (i.name.contains(txt))
               {
                   AF.request(i.url)
                   .validate()
                   .responseDecodable(of: Pokemon.self)
                   {
                       (response) in guard let pokemon = response.value else { return }
                       self.pokes.append(pokemon)
                       self.pokeTableView.reloadData()
                   }
               }
           }
       }
    }
    
    func animateIn (desiredView: UIView)
    {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    func animateOut (desiredView: UIView)
    {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    
}


extension PokemonViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return pokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as! PokemonTableViewCell
        cell.setData(poke: pokes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == self.offset + 19
        {
            offset += 20
            print("loadmore\(offset)")
            self.fetchItems()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
            vc.pokemon = pokes[indexPath.row]
            //self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
    }
    
}


extension PokemonViewController
{
    func fetchItems()
    {
         AF.request("https://pokeapi.co/api/v2/pokemon/?limit=20&offset=\(offset)")
        .validate()
        .responseDecodable(of: PrePokemons.self)
        {
            (response) in guard let items = response.value else { return }
            for i in items.all
            {
                AF.request(i.url)
                .validate()
                .responseDecodable(of: Pokemon.self)
                {
                    (response) in guard let pokemon = response.value else { return }
                    self.pokes.append(pokemon)
                    self.pokeTableView.reloadData()
                }
            }
        }
    }
    
}

