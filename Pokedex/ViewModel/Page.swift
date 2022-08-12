//
//  Page.swift
//  Pokedex
//
//  Created by Finofantashi on 08/08/2022.
//

import Foundation
import UIKit

struct Page {
    
    var vc = UIViewController()
    
    init(_vc: UIViewController) {
        
        vc = _vc
    }
}

struct PageCollection {
    
    var pages = [Page]()
    var selectedPageIndex = 0 //The first page is selected by default in the beginning
}
