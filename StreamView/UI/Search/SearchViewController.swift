//
//  SearchViewController.swift
//  StreamView
//
//  Created by Dark Matter on 18/08/21.
//

import Foundation
import UIKit
import KRProgressHUD

class SearchViewController : UIViewController{
    private var albums = [Album]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self
    }
    
}

extension SearchViewController  : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Query \(searchText)")
        print("Query isEmpty \(searchText.isEmpty)")
        if searchText.isEmpty {return}
       // KRProgressHUD.show()
        streamProvider.search(page: 1, query: searchText) { albums in
            print("Albums \(albums)")
           // KRProgressHUD.dismiss()
            self.albums = albums
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        if let moview = album as? Movie{
            self.openMovieDetail(moview)
        }
        if let show = album as? TvSeries{
            openTvSeriesDetails(show)
        }
    }
}

extension SearchViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let album = albums[indexPath.row]
        if let moview = album as? Movie{
            cell.name.text = moview.title
            setImageFromNetwork(url: moview.thumbnail ?? placeHolderImage, imageView: cell.thumbnailImg)
        }
        if let show = album as? TvSeries{
            cell.name.text = show.title
            setImageFromNetwork(url: show.thumbnail, imageView: cell.thumbnailImg)
        }
        return cell
    }
}
