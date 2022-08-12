//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by SMin on 04/08/2022.
//

import UIKit
import Alamofire
import BetterSegmentedControl

enum DragDirection {
    case Up
    case Down
}

protocol InnerTableViewScrollDelegate: AnyObject {
    
    var currentHeaderHeight: CGFloat { get }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection)
}

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var typeTag: UIImageView!
    @IBOutlet weak var script: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var segmentFromLib: BetterSegmentedControl!
    
    var pokemon : Pokemon?
    var speciesProp : SpeciesProp?
    
    var pageViewController = UIPageViewController()
    var pageCollection = PageCollection()
    
    var topViewInitialHeight : CGFloat = 420
    let topViewFinalHeight : CGFloat = 0
    var topViewHeightConstraintRange: Range<CGFloat>? = nil
    var oldIndex = 0
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTopViewHeight()
//        setupBottom()
        setupSegment()
        GUI()
    }
    
    // MARK: - Function
    func GUI()
    {
        setGradientBackground()
        contentView.layer.cornerRadius = 48
        bottomView.layer.cornerRadius = 48
        loadingImg(url: pokemon!.sprites.other.official.img)
        typeTag.image = UIImage(named: pokemon!.types[0].pokeType.name + "Tag")
        name.text = pokemon!.name.capitalized
        fetchSpecies(url: pokemon!.species.url)
    }
    
    func loadingImg(url: String) {
        let url = URL(string: url)
        img.kf.setImage(with: url, placeholder: UIImage(named: "ic_pokemon_placeholder"), options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25))
        ])
    }
    
    func setGradientBackground() {
        let colorLeft =  UIColor(red: 85.0/255.0, green: 194.0/255.0, blue: 251.0/255.0, alpha: 1.0).cgColor
        let colorRight = UIColor(red: 145.0/255.0, green: 235.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func fetchSpecies(url: String) {
        AF.request(url)
            .validate()
            .responseDecodable(of: SpeciesProp.self)
        {
            (response) in guard let items = response.value else { return }
            self.speciesProp = items
            self.script.text = items.textEntries.first(where: { $0.language.name == "en" && $0.version.name == "omega-ruby"})!.flavorText.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
            self.setupBottom()
        }
    }
    
    func setupSegment() {
        segmentFromLib.segments = LabelSegment.segments(withTitles: ["STATS", "EVOLUTIONS", "MOVES"],
                                                  normalTextColor: #colorLiteral(red: 0.3333333333, green: 0.6196078431, blue: 0.8745098039, alpha: 1),
                                                        selectedTextColor: .white)
    }
    
    func updateTopViewHeight() {
        topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight
    }
    
    func setupBottom() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Setup PageView
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonStatsViewController") as? PokemonStatsViewController
        firstVC?.pokemon = self.pokemon
        firstVC?.speciesProp = self.speciesProp
        firstVC?.innerTableViewScrollDelegate = self
        let page1 = Page(_vc: firstVC!)
        pageCollection.pages.append(page1)
        
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "EvolutionViewController") as? EvolutionViewController
        secondVC?.innerTableViewScrollDelegate = self
        secondVC?.pokemon = self.pokemon
        secondVC?.speciesProp = self.speciesProp
        let page2 = Page(_vc: secondVC!)
        pageCollection.pages.append(page2)
        
        let thirdVC = self.storyboard?.instantiateViewController(withIdentifier: "MovesViewController") as? MovesViewController
        thirdVC?.innerTableViewScrollDelegate = self
        thirdVC?.pokemon = self.pokemon
        let page3 = Page(_vc: thirdVC!)
        pageCollection.pages.append(page3)
        
        let initialPage = 0
        
        pageViewController.setViewControllers([pageCollection.pages[initialPage].vc],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        subView.addSubview(pageViewController.view)
        subView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leadingAnchor.constraint(equalTo: subView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: subView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: subView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: subView.bottomAnchor).isActive = true
    }
    
    func setPageView(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        
        pageViewController.setViewControllers([pageCollection.pages[index].vc],
                                              direction: navigationDirection,
                                              animated: true,
                                              completion: nil)
    }
    
    // MARK: - View action
//    @IBAction func tappedSegment(_ sender: Any) {
//
//        var direction: UIPageViewController.NavigationDirection
//
//        if segmentController.selectedSegmentIndex == 0 {
//
//            direction = .reverse
//
//            setPageView(toPageWithAtIndex: 0, andNavigationDirection: direction)
//            segmentController.selectedSegmentIndex = 0
//        } else if segmentController.selectedSegmentIndex == 1{
//
//            direction = oldIndex == 0 ? .forward : .reverse
//
//            setPageView(toPageWithAtIndex: 1, andNavigationDirection: direction)
//            segmentController.selectedSegmentIndex = 1
//        } else {
//            direction = .forward
//
//            setPageView(toPageWithAtIndex: 2, andNavigationDirection: direction)
//            segmentController.selectedSegmentIndex = 2
//        }
//        oldIndex = segmentController.selectedSegmentIndex
//    }
    
    @IBAction func tappedLibSegment(_ sender: Any) {
        
        var direction: UIPageViewController.NavigationDirection
        
        if segmentFromLib.index == 0 {
            
            direction = .reverse
            
            setPageView(toPageWithAtIndex: 0, andNavigationDirection: direction)
        } else if segmentFromLib.index == 1{
            
            direction = oldIndex == 0 ? .forward : .reverse
            
            setPageView(toPageWithAtIndex: 1, andNavigationDirection: direction)
        } else {
            direction = .forward
            
            setPageView(toPageWithAtIndex: 2, andNavigationDirection: direction)
        }
        oldIndex = segmentFromLib.index
    }
}

extension PokemonDetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingVC = pendingViewControllers.first else { return }
        let index = pageCollection.pages.firstIndex(where: { $0.vc == pendingVC })
        segmentFromLib.setIndex(index ?? 0, animated: true, shouldSendValueChangedEvent: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        let index = pageCollection.pages.firstIndex(where: { $0.vc == currentVC })
        segmentFromLib.setIndex(index ?? 0, animated: false, shouldSendValueChangedEvent: false)
        guard index != nil else { return }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (1..<pageCollection.pages.count).contains(currentViewControllerIndex) {
                
                return pageCollection.pages[currentViewControllerIndex - 1].vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (0..<(pageCollection.pages.count - 1)).contains(currentViewControllerIndex) {
                
                return pageCollection.pages[currentViewControllerIndex + 1].vc
            }
        }
        return nil
    }
}

extension PokemonDetailViewController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        
        return headerViewHeightConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        
        headerViewHeightConstraint.constant -= scrollDistance
        
        
        if headerViewHeightConstraint.constant > topViewInitialHeight {
            
            headerViewHeightConstraint.constant = topViewInitialHeight
        }
        
        if headerViewHeightConstraint.constant < topViewFinalHeight {
            
            headerViewHeightConstraint.constant = topViewFinalHeight
        }
        
        let percentage = (headerViewHeightConstraint.constant) / 100
        
        self.stickyHeaderView.alpha = percentage
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = headerViewHeightConstraint.constant
        
        if topViewHeight <= topViewFinalHeight {
            
            scrollToFinalView()
            
        } else if topViewHeight <= topViewInitialHeight {
            
            switch scrollDirection {
                
            case .Down: scrollToInitialView()
            case .Up: scrollToFinalView()
                
            }
            
        } else {
            
            scrollToInitialView()
        }
        
        let percentage = (headerViewHeightConstraint.constant) / 100
        
        UIView.animate(withDuration: 0.25) {
            self.stickyHeaderView.alpha = percentage
        }
        
    }
    
    func scrollToInitialView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewInitialHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewInitialHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollToFinalView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewFinalHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewFinalHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
}


