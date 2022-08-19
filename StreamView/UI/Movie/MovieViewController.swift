//
//  MovieViewController.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit
import WebKit
import KRProgressHUD


class MovieViewController : UIViewController{
    var movie : Movie? = nil {
        didSet{
          //  updateMovieDetails()
        }
    }
    @IBOutlet weak var watchNowBtn: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviewDescription: UILabel!
    @IBOutlet weak var movieDetails : UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var serversCollection : UICollectionView!
    
    var webView : InterceptorWebView? = nil
    
    private var servers : [Server] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        webView = InterceptorWebView()
        webView?.frame = CGRect(x: 0, y: 0, width: 500, height: 250)
        view.addSubview(webView!)
       updateMovieDetails()
        
    }
    
  
    func updateMovieDetails(){
        guard let movie = movie else { return }
        movieTitle.text = movie.title
        setImageFromNetwork(url: movie.thumbnail ?? placeHolderImage, imageView: thumbnail)
        setLoading(true)
        KRProgressHUD.show()
        streamProvider.getMovieDetails(movie: movie) { movie in
            KRProgressHUD.dismiss()
            self.movie = movie
            self.moviewDescription.text = movie.description
            self.setLoading(false)
            guard let url = self.movie?.streamLink else {return}
            guard let movie = self.movie else {return}
            
            
            
            self.movieDetails.text = "Year: \(movie.year)\nGenre: \(movie.genre?.joined(separator: ","))\nCasts: \(movie.casts?.joined(separator: ","))\nDuration: \(movie.duration)\nProduction: \(movie.production)"
        }
        
    }
    
    @IBAction func watchNowAction(_ sender: UIButton) {
      
        guard let url = self.movie?.streamLink else {return}
        guard let webView = webView else {return}
       
        setLoading(true)
        
        //KRProgressHUD.show(withMessage: createRandomMessage())
        streamProvider.generateVideoSource(interceptorWebView: webView,  id: movie?.id ?? "", isMovie:  true, mainUrl: url) { data in
            KRProgressHUD.dismiss()
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



extension MovieViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var url = servers[indexPath.row].id
        print("Server Url : Url \(url)")
        url = "https://dood.watch/e/nnmdmk65hl70"
        guard let webView = webView else {return}
        setLoading(true)
        KRProgressHUD.show(withMessage: createRandomMessage())
       /* streamProvider.generateVideoUrl(interceptorWebView: webView, id: url, isMovie: true) { source in
            KRProgressHUD.dismiss()
            print("Data \(source)")
            self.setLoading(false)
            self.openWithVlc(source)
        }*/
    }
    
}

extension MovieViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerCell", for: indexPath) as! ServerCell
        cell.serverName.text = servers[indexPath.row].name
        return cell
    }
    
    

}
