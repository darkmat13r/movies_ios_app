//
//  MovieViewController.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit
import WebKit


class MovieViewController : UIViewController{
    var movie : Movie? = nil {
        didSet{
          //  updateMovieDetails()
        }
    }
    @IBOutlet weak var watchNowBtn: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviewDescription: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var webView : InterceptorWebView? = nil
    
    
    override func viewDidAppear(_ animated: Bool) {
        webView = InterceptorWebView()
       updateMovieDetails()
        
    }
    func updateMovieDetails(){
        guard let movie = movie else { return }
        movieTitle.text = movie.title
        setImageFromNetwork(url: movie.thumbnail, imageView: thumbnail)
        setLoading(true)
        streamProvider.getMovieDetails(movie: movie) { movie in
            self.movie = movie
            self.moviewDescription.text = movie.description
            self.setLoading(false)
        }
    }
    
    @IBAction func watchNowAction(_ sender: UIButton) {
        print("Data \(self.movie?.streamLink)")
        guard let url = self.movie?.streamLink else {return}
        guard let webView = webView else {return}
       
       setLoading(true)
        streamProvider.generateVideoSource(interceptorWebView: webView,  id: movie?.id ?? "", isMovie:  true, mainUrl: url) { data in
            print("Data \(data)")
            self.setLoading(false)
            self.openWithVlc(data)
        }
    }
    
   
    
    func setLoading(_ isLoading : Bool){
        watchNowBtn.isEnabled = !isLoading
        watchNowBtn.setTitle(isLoading ? "Loading..." : "Watch Now", for: .disabled)
        watchNowBtn.setTitle(isLoading ? "Loading..." : "Watch Now", for: .normal)
    }
}



