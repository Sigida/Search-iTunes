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
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       createSerchBar()
       registerNibs()
  
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
        let searchBar = UISearchBar()
        searchBar.placeholder = "Artist Name"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()//show keyboard when start the app
    }
   
    //create url
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
         let urlString = String(format:
        "https://itunes.apple.com/search?term=%@&entity=album", encodedText)
        // let urlString = "https://itunes.apple.com/lookup?id=879273552&entity=song"
       // let urlString = String(format:
       //     "https://itunes.apple.com/lookup?id=%@&entity=song", encodedText)
        
        let url = URL(string: urlString)
        return url!
    }
    
    func parse(data: Data) -> [Album] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Albums.self, from:data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
          searchBar.resignFirstResponder()
        dataTask?.cancel()//stop previous search
        isLoading = true
        collectionView.reloadData()
        hasSearched = true
        searchResults = []
       
        let url = self.iTunesURL(searchText: searchBar.text!)
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            print("On main thread? " + (Thread.current.isMainThread ? "Yes" : "No"))
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    DispatchQueue.main.async {
                        //print("On main thread? " + (Thread.current.isMainThread ? "Yes" : "No"))
                        self.isLoading = false
                        self.collectionView.reloadData()
                    }
                    return
                }
            } else {
                print("Failure! \(response!)")
            }
        
        })
        dataTask?.resume()//start search
    }
    }
}

 extension SearchViewController: UICollectionViewDelegate,
 UICollectionViewDataSource {
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  if isLoading {
    return 1
 } else if !hasSearched {
    return 0
 } else if searchResults.count == 0 {
    return 1
 } else {
    return searchResults.count
 }
 }
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    if isLoading {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCellIdentifiers.loadingCell,
                                                                  for:indexPath)
    let spinner = cell.viewWithTag(700) as! UIActivityIndicatorView
        spinner.startAnimating()
    return cell
    } else if searchResults.count == 0 {
    return collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCellIdentifiers.nothingFoundCell,
                                                           for:indexPath)
 } else {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                   CollectionViewCellIdentifiers.searchAlbumCell,
                                                               for: indexPath) as! SearchAlbumCell
 let searchResult = searchResults[indexPath.row]
 cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
 cell.albumNameLabel.text = searchResult.albumName
        print(searchResult.albumID)
  
 return cell
 }
 }
 }

