//
//  SerchAlbumCell.swift
//  ItunesSearch
//
//  Created by Admin on 26.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

class SearchAlbumCell: UICollectionViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
 
    func configure(for result: Album) {
        albumNameLabel.text = result.albumName
        if let imageURL = URL(string: result.image) {
            downloadTask = artworkImageView.loadImage(url: imageURL)
        }
    }

}
