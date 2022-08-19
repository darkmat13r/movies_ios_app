//
//  ViewController.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import UIKit
import KRProgressHUD

var streamProvider = DataProvider()
class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    let sectionCellIdentifier = "HomeSectionCell"
   
    
    var homeData : [Section]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        KRProgressHUD.show()
        streamProvider.getHomeData { homeData in
            KRProgressHUD.dismiss()
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
        guard  let homeData = homeData else{
            return cell
        }
        let section = homeData[indexPath.row]
        cell.title.text = section.name
        if section.movies.count > 0{
            cell.data = section.movies
        }else {
            cell.data = section.shows
        }
        cell.onSelectMovie = { moview in
            self.openMovieDetail(moview)
        }
        cell.onSelectSeries = { series in
            self.openTvSeriesDetails(series)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
