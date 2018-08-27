//
//  ViewController.swift
//  ItunesSearch
//
//  Created by Admin on 26.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       createSerchBar()
        //Register nibs
    var cellNib = UINib(nibName:CollectionViewCellIdentifiers.searchResultCell,
                        bundle:nil)
    collectionView.register(cellNib,
                        forCellWithReuseIdentifier:CollectionViewCellIdentifiers.searchResultCell)
    cellNib = UINib(nibName:CollectionViewCellIdentifiers.nothingFoundCell,
                    bundle:nil)
    collectionView.register(cellNib,
                        forCellWithReuseIdentifier:CollectionViewCellIdentifiers.nothingFoundCell)
    cellNib = UINib(nibName:CollectionViewCellIdentifiers.loadingCell,
                    bundle:nil)
    collectionView.register(cellNib,
                            forCellWithReuseIdentifier:CollectionViewCellIdentifiers.loadingCell)
    }
    func createSerchBar(){
        let searchBar = UISearchBar()
        searchBar.placeholder = "Artist Name"
        searchBar.delegate = self as? UISearchBarDelegate
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()//show keyboard when start the app
    }
}

