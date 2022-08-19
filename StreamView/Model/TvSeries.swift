//
//  TvSeries.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
class TvSeries : Album{
    var id  : String = ""
    var title : String = ""
    var url : String = ""
    var thumbnail : String = ""
    var description  : String = ""
    var rating : String = ""
    var genre : [String] = []
    var seasons : [ Season] = []
    
    var latestSeason : String  = ""
    var latestEpidode : String  = ""
    
    var releasd : String = ""
    var production : String = ""
    var countries : [String] = []
    var casts : [String] = []
    
    init(url : String, thumbnail :String, title : String, description : String, rating : String,
        latestEpisode : String, latestSeason : String){
        self.url = url
        self.thumbnail = thumbnail
        self.title = title
        self.description = description
        self.rating  = rating
        self.latestSeason = latestSeason
        self.latestEpidode = latestEpisode
    }

}
