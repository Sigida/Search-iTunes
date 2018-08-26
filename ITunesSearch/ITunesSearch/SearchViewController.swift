//
//  ViewController.swift
//  ITunesSearch
//
//  Created by Admin on 25.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //dissmiss Keybord
        searchBar.resignFirstResponder()
        
        print("The search text is: '\(searchBar.text!)'")
        searchResults = []
        if searchBar.text! != "Amanda"{
            for i in 0...2 {
                let searchResult = SearchResult()
                searchResult.name = String(format: "Fake Result %d for", i)
                searchResult.artistName = searchBar.text!
                searchResults.append(searchResult)
            }
        }
        hasSearched = true
       collectionView.reloadData()
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
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
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
       // let textData = listOfMove[indexPath.row]
        if searchResults.count == 0 {
            cell.nameLabel.text = "(Nothing found)"
           cell.artistNameLabel.text = ""
          
        } else {
        let searchResult = searchResults[indexPath.row]
       cell.nameLabel.text = searchResult.name
        cell.artistNameLabel.text = searchResult.artistName
       // cell.imageURL = URL(string: textData.linkImage)
       // cell.setImage()
          
  
       }
         return cell
}
}

