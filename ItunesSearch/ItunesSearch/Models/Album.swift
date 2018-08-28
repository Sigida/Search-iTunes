//
//  AlbumsSearchResult.swift
//  ItunesSearch
//
//  Created by Admin on 27.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import Foundation
class Albums:Codable {
    var resultCount = 0
    var results = [Album]()
}
class Album: Codable {
 
    var artistName: String
    var albumID:Int = 0
    var albumName:String
    var trackName:String?
    var image : String
    var collectionPrice : Double
    var trackCount:Int
    var releaseDate:String
    var genre:String
    
    enum CodingKeys: String, CodingKey {
        case image = "artworkUrl100"
        case albumName  = "collectionName"
        case albumID = "collectionId"
        case genre = "primaryGenreName"
        case artistName, trackName
        case collectionPrice
        case trackCount
        case releaseDate
    }


    static func < (lhs: Album, rhs: Album) -> Bool {
        return lhs.albumName.localizedStandardCompare(rhs.albumName) == .orderedAscending
    }
    
    
}
    

