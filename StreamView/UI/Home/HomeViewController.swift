//
//  ViewController.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import UIKit

var streamProvider = StreamFlixProvider()
class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    let sectionCellIdentifier = "HomeSectionCell"
   
    
    var homeData : HomeData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        streamProvider.getHomeData { homeData in
            self.homeData = homeData
            self.tableView.reloadData()
        }
        tableView.autoresizesSubviews = true
    }


}


extension HomeViewController : UITableViewDataSource{
    
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData != nil ? 4 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellIdentifier, for: indexPath) as! HomeSectionCell
        if indexPath.row == 0{
            cell.title.text = "Trending Movies"
            cell.data  = homeData?.trendingMovies ?? []
        }
        if indexPath.row == 1{
            cell.title.text = "Trending Series"
            cell.data  = homeData?.trendingTvSeries ?? []
        }
        if indexPath.row == 2{
            cell.title.text = "Latest Movies"
            cell.data  = homeData?.latestMovies ?? []
        }
        if indexPath.row == 3{
            cell.title.text = "Latest Series"
            cell.data  = homeData?.latestSeries ?? []
        }
        cell.onSelectMovie = { moview in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
            vc.movie = moview
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.onSelectSeries = { series in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
            vc.series = series
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
