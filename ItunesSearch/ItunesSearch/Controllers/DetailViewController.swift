//
//  DetailViewController.swift
//  ItunesSearch
//
//  Created by Admin on 26.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
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
    private let songList = SearchService()
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchResult != nil {
            updateUI()
        }
        showSongs()
    }
    
    func updateUI() {
        albumNameLabel.text = searchResult.albumName
        genreLabel.text = searchResult.genre
        artistNameLabel.text = searchResult.artistName
        trackCountLabel.text = "Tracks: \(String(searchResult.trackCount))"
        genreLabel.text = searchResult.genre
        // Get date
        let date = getDateRelease(dateString: searchResult.releaseDate!)
        releaseDateLabel.text = "Release: \(date)"
        // Get image
        if let imageURL = URL(string: searchResult.image) {
            downloadTask = artworkImageView.loadImage(url: imageURL)
        }
    }
    func getDateRelease(dateString:String)->String {
        var dateString = dateString
        let range = dateString.index(dateString.endIndex, offsetBy: -10)..<dateString.endIndex
        dateString.removeSubrange(range)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy"
        let newDate = dateFormatter.string(from: date!)
        return newDate
    }
    func showSongs(){
        songList.getSongsForAlbum(with: searchResult.albumID) { (resalts) in
            self.songs = resalts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //cencel load image
    deinit {
        downloadTask?.cancel()
    }
}
// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = TableViewCellIdentifiers.SongCell
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default,
                                   reuseIdentifier: cellIdentifier)
        }
        cell.textLabel!.text = songs[indexPath.row]
        return cell
    }
}

