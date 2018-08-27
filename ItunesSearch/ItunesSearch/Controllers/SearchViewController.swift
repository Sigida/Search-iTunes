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
    // MARK: - Properties
    var searchResults = [Album]()
    var  hasSearched = false
    override func viewDidLoad() {
        super.viewDidLoad()
       createSerchBar()
        //Register nibs
    var cellNib = UINib(nibName:CollectionViewCellIdentifiers.searchAlbumCell,
                        bundle:nil)
    collectionView.register(cellNib,
                        forCellWithReuseIdentifier:CollectionViewCellIdentifiers.searchAlbumCell)
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
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()//show keyboard when start the app
    }
}

 extension SearchViewController: UISearchBarDelegate {
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 if !searchBar.text!.isEmpty {
 //dissmiss Keybord
 searchBar.resignFirstResponder()
 searchResults = []
 if searchBar.text! != "Amanda"{
 for _ in 0...2 {
 let searchResult = Album()
 searchResult.albumName = searchBar.text!
 searchResults.append(searchResult)
 }
 }
 hasSearched = true
  collectionView.reloadData()
 }
 }
 }
 extension SearchViewController: UICollectionViewDelegate,
 UICollectionViewDataSource {
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 if !hasSearched {
 return 0
 } else if searchResults.count == 0 {
 return 1
 } else {
 return searchResults.count
 }
 }
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
 if searchResults.count == 0 {
 return collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCellIdentifiers.nothingFoundCell,
                                                           for:indexPath)
 } else {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                   CollectionViewCellIdentifiers.searchAlbumCell,
                                                               for: indexPath) as! SearchAlbumCell
 let searchResult = searchResults[indexPath.row]
 cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
 cell.albumNameLabel.text = searchResult.albumName
  
 return cell
 }
 }
 }

