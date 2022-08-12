//
//  MovesViewController.swift
//  Pokedex
//
//  Created by SMin on 11/08/2022.
//

import UIKit
import Alamofire

class MovesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var pokemon : Pokemon?
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    var moves = [ListMove]()
    var moveDetail = [MoveDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        // Do any additional setup after loading the view.
    }
    
    func getData()
    {
        for i in pokemon!.moves
        {
            if (i.versionDetail.first(where: { $0.version.name == "x-y" && $0.level != 0 }) != nil)
            {
                moves.append(i)
            }
        }
        moves = moves.sorted { $0.versionDetail.first(where: { $0.version.name == "x-y" })!.level < $1.versionDetail.first(where: { $0.version.name == "x-y" })!.level }
        for i in stride(from: 0, to: moves.count , by: 1)
        {
            fetchMove(url: moves[i].move.url)
        }
    }
    
    func fetchMove(url: String) {
        AF.request(url)
            .validate()
            .responseDecodable(of: MoveDetail.self)
        {
            (response) in guard let items = response.value else { return }
            self.moveDetail.append(items)
            self.tableView.reloadData()
        }
    }
}


//Table
extension MovesViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoveTableViewCell", for: indexPath) as! MoveTableViewCell
        cell.name.text = moves[indexPath.row].move.name.capitalized.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
        cell.level.text = "Level " + String(moves[indexPath.row].versionDetail.first(where: { $0.version.name == "x-y"})!.level)
        if (moveDetail.count == moves.count)
        {
            cell.type0.image = UIImage(named: moveDetail[indexPath.row].type.name)
        }
        return cell
    }
}


extension MovesViewController: UIScrollViewDelegate {
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
