//
//  DetailViewController.swift
//  ItunesSearch
//
//  Created by Admin on 26.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    var searchResult: Album!
    var songs = [String]()
    var downloadTask: URLSessionDownloadTask?
    
   private let search = SearchService()
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchResult != nil {
            updateUI()
        }
        search.getSongsForAlbum(with: searchResult.albumID ) { (resalts:[String]) in
            self.songs = resalts
            print(resalts)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        print ("releaseDte\(String(describing: releaseDateLabel.text))")
        // Get image
        if let imageURL = URL(string: searchResult.image) {
            downloadTask = artworkImageView.loadImage(url: imageURL)
        }
    }
    
}
extension DetailViewController: UITableViewDelegate,
UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                     numberOfRowsInSection section: Int) -> Int {
        print(songs.count)
        return songs.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = TableViewCellIdentifiers.SongCell
        var cell:UITableViewCell! = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default,
                                   reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel!.text = songs[indexPath.row]
        return cell
    }
    
}

