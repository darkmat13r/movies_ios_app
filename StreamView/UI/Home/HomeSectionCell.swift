//
//  HomeSectionCell.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit

class HomeSectionCell : UITableViewCell{
    let movieCellIdentifier = "MovieCell"
    @IBOutlet weak var thubnail: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    var onSelectMovie : (_ movie : Movie) -> Void = {_ in }
    var onSelectSeries :  (_ series : TvSeries) -> Void = {_ in}
    
    var data : [Album] = [] {
        didSet{
            updateThumbnails()
        }
    }
    
    
    
    
    func updateThumbnails(){
        thubnail.dataSource = self
        thubnail.delegate = self
    }
}


extension HomeSectionCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = data[indexPath.row]
        if album is Movie{
            let movie = album as! Movie
          onSelectMovie(movie)
        }else if album is TvSeries{
            let tvSeries = album as! TvSeries
            onSelectSeries(tvSeries)
        }
    }
}

extension HomeSectionCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellIdentifier, for: indexPath) as! MovieCell
        let album = data[indexPath.row]
        if album is Movie{
            let movie = album as! Movie
            setImageFromNetwork(url: movie.thumbnail ?? placeHolderImage, imageView: cell.thumbnailImg)
            cell.name.text = movie.title
        }else if album is TvSeries{
            let tvSeries = album as! TvSeries
            setImageFromNetwork(url: tvSeries.thumbnail, imageView: cell.thumbnailImg)
            cell.name.text = tvSeries.title
        }
        
        return cell
    }
    
    
    
}
