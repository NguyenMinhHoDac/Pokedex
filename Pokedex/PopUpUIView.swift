//
//  PopUpUIView.swift
//  Pokedex
//
//  Created by SMin on 05/08/2022.
//

import UIKit
import Alamofire

class PopUpUIView: UIView {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    @IBOutlet weak var typeCollection: UICollectionView!
    
    var double = Set<String>()
    var half = Set<String>()
    var no = Set<String>()
    
    func loadingImg(url: String)
    {
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async
            {
                if error != nil {
                    print("Error fetching the image!")
                } else {
                    self.img.image = UIImage(data: data!)
                }
            }
        }
        dataTask.resume()
    }
    
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
            print(self.double)
            self.typeCollection.reloadData()
        }
    }
    

    func reSetData()
    {
        img.image = nil
        type1.image = nil
        type2.image = nil
        double = []
        half = []
        no = []
    }
    
    func setRelation()
    {
        
    }
    
    func setData(poke: Pokemon)
    {
        reSetData()
        
        typeCollection.dataSource = self
        typeCollection.delegate = self
        
        id.text = "#" + String(format: "%03d", poke.id)
        loadingImg(url: poke.sprites.other.official.img)
        name.text = poke.name
        type1.image = UIImage(named: poke.types[0].pokeType.name)
        fetchType(url: poke.types[0].pokeType.url)
        if (poke.types.count == 2)
        {
            fetchType(url: poke.types[1].pokeType.url)
            type2.image = UIImage(named: poke.types[1].pokeType.name)
        }
       
    }

}

extension PopUpUIView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
        cell.icon.image = UIImage(named: type[indexPath.row]!)
        cell.value.text = "1x"
        if (double.contains(type[indexPath.row]!))
            { cell.value.text = "2x"}
        if (half.contains(type[indexPath.row]!))
            { cell.value.text = "1/2x"}
        if (no.contains(type[indexPath.row]!))
            { cell.value.text = "0x"}
        return cell
    }
}
