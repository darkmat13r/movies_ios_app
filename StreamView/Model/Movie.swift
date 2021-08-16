//
//  Movie.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit

class Movie :Album{
    var id  : String = ""
    var url  : String = ""
    var thumbnail : String = ""
    var title : String = ""
    var description : String = ""
    var genre : [String] = []
    
    var duration : String = ""
    var rating : String = ""
    var year : String = ""
    var releasd : String = ""
    var production : String = ""
    var countries : [String] = []
    var casts : [String] = []
    var streamLink : String = ""
    
    init(url : String, thumbnail :String, title : String, description : String, duration : String, rating : String, year : String){
        self.url = url
        self.thumbnail = thumbnail
        self.title = title
        self.description = description
        self.duration = duration
        self.rating  = rating
    }

    
}
