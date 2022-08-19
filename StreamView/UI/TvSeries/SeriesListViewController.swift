//
//  SeriesListViewController.swift
//  StreamView
//
//  Created by Dark Matter on 18/08/21.
//

import Foundation
import UIKit
import KRProgressHUD
class SeriesListViewController : UIViewController{
    var tvSeriesList =  [TvSeries]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        KRProgressHUD.show()
        streamProvider.getTvSeries(page: 1) { shows in
            KRProgressHUD.dismiss()
            self.tvSeriesList = shows
            self.collectionView.reloadData()
        }
    }
    
}
extension SeriesListViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let series = tvSeriesList[indexPath.row]
        openTvSeriesDetails(series)
    }
}
extension SeriesListViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvSeriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let series = tvSeriesList[indexPath.row]
        cell.name.text = series.title
        setImageFromNetwork(url: series.thumbnail, imageView: cell.thumbnailImg)
        return cell
    }
    
    
}
