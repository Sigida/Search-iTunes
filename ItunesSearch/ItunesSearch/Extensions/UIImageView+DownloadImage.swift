//
//  UIImageView+DownloadImage.swift
//  ItunesSearch
//
//  Created by Admin on 28.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        // saves the downloaded file to a temporary location on disk instead of keeping it in memory.
        let downloadTask = session.downloadTask(with: url,
                                                completionHandler: { [weak self] url, response, error in
                                                 
                                                    if error == nil, let url = url,
                                                        let data = try? Data(contentsOf: url),
                                                        let image = UIImage(data: data) {
                                                      
                                                        DispatchQueue.main.async {
                                                            if let weakSelf = self {
                                                                weakSelf.image = image
                                                            }
                                                        }
                                                    }
        })
        downloadTask.resume()
        return downloadTask
    }
}
    

