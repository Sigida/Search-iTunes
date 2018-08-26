//
//  ViewController.swift
//  ItunesSearch
//
//  Created by Admin on 26.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       createSerchBar()
    }

    func createSerchBar(){
        let searchBar = UISearchBar()
       // searchBar.showsCancelButton = true
        searchBar.placeholder = "Artist Name"
        searchBar.delegate = self as? UISearchBarDelegate
        self.navigationItem.titleView = searchBar
    }

}

