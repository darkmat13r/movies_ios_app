//
//  StreamProvider.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation

protocol StreamProdvider{
    func search(page : Int, query : String, completion : @escaping (_ albums : [Album]) -> Void)
    func getMovies(page : Int, completion : @escaping (_ movies : [Movie]) -> Void)
    func getTvSeries(page : Int, completion : @escaping (_ tvseries : [TvSeries] ) -> Void)
    func getMovieDetails(movie : Movie, completion : @escaping ( _ movie : Movie) -> Void)
    func getTvSeriesDetails(series : TvSeries , completion : @escaping (_ series : TvSeries) -> Void)
    func getHomeData(completion: @escaping ([Section]) -> Void)
    func generateVideoSource(interceptorWebView : InterceptorWebView,  id: String, isMovie : Bool, mainUrl :String, completion : @escaping (_ videoSource : ViewSource) -> Void)
}
