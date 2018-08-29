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
    private let search = SearchService()
    let searchBar = UISearchBar()
    
   override func viewDidLoad() {
        super.viewDidLoad()
       createSerchBar()
       registerNibs()
  
    }
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showDetail {
            if case .results(let list) = search.state {
                let detailViewController = segue.destination
                    as! DetailViewController
                let indexPath = sender as! IndexPath
                let searchResult = list[indexPath.row]
                detailViewController.searchResult = searchResult
            }
        }
    }
    
    func registerNibs(){
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
        searchBar.placeholder = "Artist Name"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()//show keyboard when start the app
    }
   
  
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performAlbumSearch()

}
    func performAlbumSearch() {
        search.performSearch(for: searchBar.text!,completion: { success in
            if !success {
                self.showNetworkError()
            }
            self.collectionView.reloadData()
        })
        
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}
 extension SearchViewController: UICollectionViewDelegate,
 UICollectionViewDataSource {
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch search.state {
    case .notSearchedYet:
        return 0
    case .loading:
        return 1
    case .noResults:
        return 1
    case .results(let list):
        return list.count
    }
    }
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    switch search.state {
    case .notSearchedYet:
        fatalError("Should never get here")
        
    case .loading:
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCellIdentifiers.loadingCell,
            for: indexPath)
        
        let spinner = cell.viewWithTag(700) as!
        UIActivityIndicatorView
        spinner.startAnimating()
        return cell
        
    case .noResults:
    
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell,
            for: indexPath)
        
    case .results(let list):
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCellIdentifiers.searchAlbumCell,
            for: indexPath) as! SearchAlbumCell
        
        let searchResult = list[indexPath.row]
        cell.configure(for: searchResult)
        return cell
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier:Constants.Segue.showDetail, sender: indexPath)
    }
 }

