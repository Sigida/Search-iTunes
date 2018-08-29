//
//  SearchService.swift
//  ItunesSearch
//
//  Created by Admin on 29.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import Foundation
import UIKit

class SearchService {
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([Album])
    }
    
    typealias SearchComplete = (Bool) -> Void
    
    // MARK:- Private Properties
    private(set) var state: State = .notSearchedYet
    private var dataTask: URLSessionDataTask? = nil
    
    // MARK:- Private Methods
    //create urls
    private func iTunesAlbumURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?" + "term=\(encodedText)&entity=album"
        let url = URL(string: urlString)
        return url!
    }
    private func iTunesSongURL(albumID: Int) -> URL {
        let urlString = String(format:"https://itunes.apple.com/lookup?id=%d&entity=song", albumID)
        let url = URL(string: urlString)
        return url!
    }
    //parse JSON
    private func parse(data: Data) -> [Album] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Albums.self, from:data)
            return result.results
        } catch {
            print("JSON Error: \(error.localizedDescription)")
            return []
        }
    }
    // MARK: -  Methods
    func performSearch(for text: String,completion: @escaping SearchComplete){
        if !text.isEmpty {
            dataTask?.cancel()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            state = .loading
            let url = iTunesAlbumURL(searchText: text)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url, completionHandler: {
                data, response, error in
                var success = false
                var newState = State.notSearchedYet
                // Was the search cancelled?
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let data = data {
                    var searchResults = self.parse(data: data)
                    if searchResults.isEmpty {
                        newState = .noResults
                    }else {
                        searchResults.sort(by: <)
                        newState = .results(searchResults)
                    }
                    success = true
                }
                DispatchQueue.main.async {
                    self.state = newState
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(success)
                }
            })
            dataTask?.resume()
        }
    }
    func getSongsForAlbum(with albumId:Int, completion: @escaping ([String]) -> Void){
        let url = iTunesSongURL(albumID: albumId)
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            var songArray:[String] = []
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data {
                let searchResults = self.parse(data: data)
                for result in searchResults {
                    if let trackName = result.trackName {
                        songArray.append(trackName)
                    }
                }
                DispatchQueue.main.async {
                    completion(songArray)
                }
            }
        })
        dataTask?.resume()
    }
}


    


    

