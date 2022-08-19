//
//  MoviesViewController.swift
//  StreamView
//
//  Created by Dark Matter on 18/08/21.
//

import Foundation
import UIKit
import KRProgressHUD

class MoviesViewController : UIViewController{
    var movies = [Movie]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        KRProgressHUD.show()
        streamProvider.getMovies(page: 1) { movies in
            KRProgressHUD.dismiss()
            self.movies = movies
            self.collectionView.reloadData()
        }
    }
}

extension MoviesViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        openMovieDetail(movie)
    }
}

extension MoviesViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.name.text = movie.title
        setImageFromNetwork(url: movie.thumbnail ?? placeHolderImage, imageView: cell.thumbnailImg)
        return cell
    }
    
    
}
