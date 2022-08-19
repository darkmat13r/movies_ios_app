//
//  DataProvider.swift
//  StreamView
//
//  Created by Dark Matter on 06/07/22.
//

import Foundation
import Alamofire
class DataProvider : StreamProdvider{
    private  let BASE_URL = "https://streamflix-movies-test.herokuapp.com/"
    func search(page: Int, query: String, completion: @escaping ([Album]) -> Void) {
        AF.request("\(BASE_URL)search/\(query)?page=\(page)").responseData { data in
            
        }
    }
    
    func getMovies(page: Int, completion: @escaping ([Movie]) -> Void) {
        AF.request("\(BASE_URL)movies?page=\(page)").responseData { data in
            
        }
    }
    
    func getTvSeries(page: Int, completion: @escaping ([TvSeries]) -> Void) {
        AF.request("\(BASE_URL)shows?page=\(page)").responseData { data in
            
        }
    }
    
    func getMovieDetails(movie: Movie, completion: @escaping (Movie) -> Void) {
        AF.request("\(BASE_URL)movies/\(movie.id)").responseData { data in
            
        }
    }
    
    func getTvSeriesDetails(series: TvSeries, completion: @escaping (TvSeries) -> Void) {
        AF.request("\(BASE_URL)shows/\(series.id)").responseData { data in
            
        }
    }
    
    func getHomeData(completion: @escaping ([Section]) -> Void) {
        var sectionsData : [Section] = []
        AF.request("\(BASE_URL)home").responseJSON(completionHandler: { response in
            switch response.result{
            case .success(let json) :
                if let sections = json  as? [Dictionary<String, Any>]{
                    for section in sections {
                        if section["movies"] != nil{
                            sectionsData.append(Section(name: section["name"] as! String, movies: parseMovies(arr: section["movies"] as! [Dictionary<String, Any>])))
                        }
                       
                    }
                    completion(sectionsData)
                }
                break
            case .failure(_):
                print("Error")
            }
        })
    }
    
    func generateVideoSource(interceptorWebView: InterceptorWebView, id: String, isMovie: Bool, mainUrl: String, completion: @escaping (ViewSource) -> Void) {
        
    }
    
    
}

func parseMovies(arr : [Dictionary<String, Any>]) -> [Movie]{
    var movies : [Movie] = []
    for movieData in arr{
        movies.append(parseMovie(dic: movieData))
    }
    return movies
}
func getImageUrl(data : Any) -> String?{
    if let data = data as? Dictionary<String, Any>{
        return data["url"] as? String
    }
    return nil
}
func parseMovie(dic : Dictionary<String, Any>) -> Movie{
    
    let movie = Movie(url: dic["id"] as! String, thumbnail: getImageUrl(data: dic["thumbnail"]) ?? "", title: dic["name"]  as! String, description: (dic["description"] as! String?), duration: dic["duration"] as! String, rating: dic["rating"] as! String as! String as! String, year: dic["year"] as! String)
    
    return movie
}
