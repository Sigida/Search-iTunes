//
//  DetailViewController.swift
//  ItunesSearch
//
//  Created by Admin on 26.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    var searchResult: Album!
    var downloadTask: URLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        if searchResult != nil {
            updateUI()
        }
    }
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    func updateUI() {
       
        albumNameLabel.text = searchResult.albumName
        genreLabel.text = searchResult.genre
        artistNameLabel.text = searchResult.artistName
        trackCountLabel.text = String(searchResult.trackCount)
        genreLabel.text = searchResult.genre
        
       
        // let formatter = DateFormatter()
        // formatter.dateStyle = .medium
        // formatter.timeStyle = .short
        // formatter.date(from: searchResult.releaseDate)
        releaseDateLabel.text = searchResult.releaseDate
     
        // Get image
        if let imageURL = URL(string: searchResult.image) {
            downloadTask = artworkImageView.loadImage(url: imageURL)
        }
    }
}
