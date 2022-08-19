//
//  HomeData.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation


class HomeData {
    var trendingMovies : [Movie] = []
    var trendingTvSeries : [TvSeries] = []
    var latestMovies : [Movie] = []
    var latestSeries : [TvSeries] = []
}


struct Section{
    var name : String = ""
    var movies : [Movie] = []
    var shows : [TvSeries] = []
}
