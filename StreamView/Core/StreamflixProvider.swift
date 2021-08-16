//
//  StreamflixProvider.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import Alamofire
import SwiftSoup
class StreamFlixProvider : StreamProdvider{
    let decoder = JSONDecoder()
    func generateVideoSource(interceptorWebView : InterceptorWebView,
                             id: String, isMovie : Bool,
                             mainUrl :String,
                             completion: @escaping (ViewSource) -> Void) {
        let url = isMovie ? "ajax/movie/episodes" : "ajax/v2/episode/servers"
        let destinationUrl = "\(baseUrl)/\(url)/\(id)"
        interceptorWebView.interceptDelegate = { url in
            //print("Intercepted Url \(url)")
            if let url = URL(string: url) {
                if url.host == "streamrapid.ru" {
                    interceptorWebView.loadUrl(url: URL(string: "about:blank"))
                    self.getVideoSources(url, completion : completion)
                }
            }
        }
        try getDocument(url: destinationUrl) { document in
            do{
                if !isMovie {
                    let element = try document.select(".nav a").first()?.attr("data-id")
                    let url = "\(mainUrl ).\(element ?? "")".replacingOccurrences(of: "/tv/", with: "/watch-tv/")
                    print("Final Url \(url)")
                    interceptorWebView.loadUrl(url: URL(string: url))
                }else{
                    let element = try self.getAbsUrl(selector: ".nav a", element: document)
                    interceptorWebView.loadUrl(url: URL(string: element ?? ""))
                }
            }catch{
                
            }
        }
        
        
    }
    
    func getVideoSources(_ url : URL , completion: @escaping (ViewSource) -> Void){
        
        AF.request(url.absoluteURL).responseJSON { response in
            print("reponse \(response)")
            do {
                if let data = response.data {
                    if let videoSource = try self.decoder.decode(ViewSource.self, from: data) as? ViewSource{
                        print("Video Sources \(videoSource)")
                        completion(videoSource)
                    }
                    
                }
            }catch{
                
            }
        }
        
    }
    
    func getHomeData(completion: @escaping (HomeData) -> Void) {
        getDocumentByPath(path: "home") { [self ] document in
            do{
                let homeData = HomeData()
                let trendingMoviesEl  = try document.select("#trending-movies .flw-item")
                try trendingMoviesEl.forEach{ element in
                    homeData.trendingMovies.append(try self.parseMovieItem(element: element))
                    
                }
                let trendingTvSeriesEl = try document.select("#trending-tv .flw-item")
                try trendingTvSeriesEl.forEach{ element in
                    homeData.trendingTvSeries.append(try self.parseTvSeriesItem(element: element))
                    
                }
                let rows = try document.select(".film-by-rows .fbr-line.fbr-content")
                try rows.forEach { row in
                    let linkEl = try row.select(".film-name a")
                    let url = try linkEl.first()?.outerHtml()
                    
                    if (url ?? "").contains("/tv/") {
                        homeData.latestSeries.append(try self.parseTvSeriesItem(element: row))
                    } else {
                        homeData.latestMovies.append(try self.parseMovieItem(element: row))
                    }
                }
                completion(homeData)
            }catch{
                
            }
        }
    }
    
    func getMovies(page: Int, completion: @escaping ([Movie]) -> Void) {
        
    }
    
    func getTvSeries(page: Int, completion: @escaping ([TvSeries]) -> Void) {
        
    }
    
    func getMovieDetails(movie: Movie, completion: @escaping (Movie) -> Void) {
        print("MoviewUrl \(movie.url)")
        getDocument(url: movie.url) { [self ] document in
            
            do{
                let detailElement = try document.select(".bah-content.detail_page").first()
                
                movie.description = try detailElement?.select(".dp-elements .description").first()?.html() ?? ""
                let otherElements = try detailElement?.select(".dp-elements .dp-element")
                if otherElements?.size() ?? 0 > 0{
                    movie.releasd = try otherElements?[0].select("span").first()?.html() ?? "-"
                }
                if otherElements?.size() ?? 0 > 2{
                    movie.rating = try otherElements?[2].select("span").first()?.html() ?? "-"
                }
                if otherElements?.size() ?? 0 > 3{
                    movie.production = try otherElements?[3].select("span").first()?.html() ?? "-"
                }
                if otherElements?.size() ?? 0 > 4{
                    try otherElements?[4].select("a").forEach({ element in
                        movie.genre.append(try element.html() )
                    })
                }
                if otherElements?.size() ?? 0 > 5{
                    try otherElements?[5].select("a").forEach({ element in
                        movie.countries.append(try element.html() )
                    })
                }
                if otherElements?.size() ?? 0 > 6{
                    try otherElements?[6].select("a").forEach({ element in
                        movie.casts.append(try element.html())
                    })
                }
                movie.id = try document.select(".watching.detail_page-watch").attr("data-id")
                print("MovieId \(movie.id)")
                
                // completion(movie)
                
            }catch{
                
            }
            getDocumentByPath(path: "ajax/movie/episodes/\(movie.id ?? "")", completion: {
                [self ] serverDoc in
                do{
                    let streamUrl  = try getAbsUrl(selector: ".nav a", element: serverDoc)
                    movie.streamLink = streamUrl ?? ""
                    completion(movie)
                }catch{
                    
                }
            })
        }
    }
    
    func getTvSeriesDetails(series: TvSeries, completion: @escaping (TvSeries) -> Void) {
        print("MoviewUrl \(series.url)")
        getDocument(url: series.url) { [self ] document in
            
            do{
                let detailElement = try document.select(".bah-content.detail_page").first()
                
                series.description = try detailElement?.select(".dp-elements .description").first()?.html() ?? ""
                let otherElements = try detailElement?.select(".dp-elements .dp-element")
                if otherElements?.size() ?? 0 > 0{
                    series.releasd = try otherElements?[0].select("span").first()?.html() ?? "-"
                }
                if otherElements?.size() ?? 0 > 2{
                    series.rating = try otherElements?[2].select("span").first()?.html() ?? "-"
                }
                if otherElements?.size() ?? 0 > 3{
                    series.production = try otherElements?[3].select("span").first()?.html() ?? "-"
                }
                if otherElements?.size() ?? 0 > 4{
                    try otherElements?[4].select("a").forEach({ element in
                        series.genre.append(try element.html() )
                    })
                }
                if otherElements?.size() ?? 0 > 5{
                    try otherElements?[5].select("a").forEach({ element in
                        series.countries.append(try element.html() )
                    })
                }
                if otherElements?.size() ?? 0 > 6{
                    try otherElements?[6].select("a").forEach({ element in
                        series.casts.append(try element.html())
                    })
                }
                series.id = try document.select(".watching.detail_page-watch").attr("data-id")
                print("MovieId \(series.id)")
                
                fetchSeasons(id: series.id) { seasons in
                    series.seasons = seasons
                    
                    completion(series)
                }
                // completion(movie)
                
            }catch{
                
            }
            
        }
    }
    
    func fetchSeasons(id:String, completion  : @escaping (_ seasons : [Season]) -> Void){
        getDocumentByPath(path: "ajax/v2/tv/seasons/\(id)") { document in
            do{
                let els = try document.select(".Seasons-list a.dropdown-item.ss-item")
                var seasons = [Season]()
                let size = els.size()
                try els.forEach { el in
                    let season = Season()
                    season.title = try el.html()
                    season.id = try el.attr("data-id")
                    self.fetchEpisodes(seasonId: season.id) { episodes in
                        season.episodes = episodes
                        seasons.append(season)
                        if seasons.count == size{
                            completion(seasons.sorted(by: { a, b in
                                a.title < b.title
                            }))
                        }
                    }
                }
            }catch{
                
            }
        }
    }
    
    func fetchEpisodes(seasonId:String, completion : @escaping (_ episodes : [Episode]) -> Void){
        getDocumentByPath(path: "ajax/v2/season/episodes/\(seasonId)") { document in
            do{
                let els = try document.select(".nav a")
                var episodes = [Episode]()
                try els.forEach { el in
                    let episode = Episode()
                    episode.title = try el.attr("title")
                    episode.id = try el.attr("data-id")
                    episode.url = "\(self.baseUrl)/\(episode.id)"
                    episodes.append(episode)
                }
                completion(episodes)
            }catch{
                
            }
        }
    }
    
    
    var baseUrl = "https://streamflix.cc"
    
    
    func parseMovieItem(element : Element)throws -> Movie {
        let url = try  getAbsUrl(selector: ".film-name a", element: element) ?? ""
        let title = try  element.select(".film-name a").first()?.html() ?? ""
        let thumbnail = try element.select(".film-poster img").first()?.absUrl("data-src") ?? ""
        let rating = try element.select(".fbrl-item.fbrl-rating").html()
        
        let  stats = try  element.select(".film-stats .item")
        var year  = ""
        var duration = ""
        if stats.count > 1{
            year  = try stats[0].html()
            duration = try stats[1].html()
        }
        
        return Movie(url: url, thumbnail: thumbnail, title: title, description: "", duration: duration, rating: rating, year: year)
    }
    
    func getAbsUrl(selector : String, element : Element) throws -> String?{
        return "\(baseUrl)\( String(describing: try element.select(selector).first()?.attr("href") ?? ""))"
    }
    
    func parseTvSeriesItem(element : Element) throws -> TvSeries{
        let url = try  getAbsUrl(selector: ".film-name a", element: element) ?? ""
        let title = try  element.select(".film-name a").first()?.html() ?? ""
        let thumbnail = try element.select(".film-poster img").first()?.absUrl("data-src") ?? ""
        let rating = try element.select(".fbrl-item.fbrl-rating").html()
        
        let  stats = try  element.select(".film-stats .item")
        var latestEpisode  = ""
        var latestSeason = ""
        if stats.count > 1{
            latestEpisode  = try stats[1].html()
            latestSeason = try stats[0].html()
        }
        
        return TvSeries(url: url,thumbnail: thumbnail, title: title, description: "", rating: rating,  latestEpisode: latestEpisode, latestSeason: latestSeason)
    }
    
    func getDocument(url :String, completion : @escaping (_ document : Document) -> Void){
        AF.request(url, method: .get).responseString{
            response in
            // print(response)
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let html: String = utf8Text
                    let doc: Document = try SwiftSoup.parse(html)
                    completion(doc)
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func getDocumentByPath(path :String, completion : @escaping (_ document : Document) -> Void){
        getDocument(url: "\(baseUrl)/\(path)", completion: completion)
    }
    
}
