//
//  SearchService.swift
//  ItunesSearch
//
//  Created by Admin on 29.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import Foundation

class SearchService {
    
    // MARK: - Properties
    var searchResults: [Album] = []
    var hasSearched = false
    var isLoading = false
    typealias SearchComplete = (Bool) -> Void
    
    
    
    private var dataTask: URLSessionDataTask? = nil
    
    //create url
    private func iTunesURL(searchText: String) -> URL {
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
    private func parse(data: Data) -> [Album] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Albums.self, from:data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func performSearch(for text: String,completion: @escaping SearchComplete){
        if !text.isEmpty {
            dataTask?.cancel()
            
            isLoading = true
            hasSearched = true
            searchResults = []
            
            let url = iTunesURL(searchText: text)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url, completionHandler: {
                data, response, error in
                 var success = false
                // Was the search cancelled?
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200, let data = data {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    
                    print("Success!")
                    self.isLoading = false
                    success = true
                    
                }
                
                if !success{
                self.hasSearched = false
                self.isLoading = false
                }
                 DispatchQueue.main.async {
                    completion(success)
                }
            })
            dataTask?.resume()
        }
    }
    
    }
    

    


    

