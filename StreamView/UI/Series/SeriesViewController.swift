//
//  SeriesViewController.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit
import KRProgressHUD

class SeriesViewController : UIViewController{
    
    var series : TvSeries? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seriesTitle: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var seasonBtn: UIButton!
    @IBOutlet weak var seriesDescription: UILabel!
    @IBOutlet weak var seriesDetails : UILabel!
    
    var selectedEpisodes = [Episode]()
    
    var interceptorWebView : InterceptorWebView? = nil
    
    @IBAction func chooseSeasonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeasonsPickerViewController") as! SeasonsPickerViewController
        vc.seasons = series?.seasons ?? []
        vc.didSelectSeason = { season in
            self.selectedEpisodes = season.episodes
            self.seasonBtn.setTitle(season.title, for: .normal)
            self.tableView.reloadData()
            
        }
        present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        interceptorWebView = InterceptorWebView()
        guard let series = series else {return }
        updateInfo(series)
        KRProgressHUD.show()
        interceptorWebView?.frame = CGRect(x: 0, y: 0, width: 230, height: 230)
        if let interceptorWebView = interceptorWebView{
            
         //   self.view.addSubview(interceptorWebView)
        }
        streamProvider.getTvSeriesDetails(series: series) { series in
            KRProgressHUD.dismiss()
            self.series = series
            self.updateInfo(series)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func updateInfo(_ series : TvSeries){
        self.seriesTitle.text = series.title
        self.seriesDescription.text = series.description
        self.seriesDetails.text = "Year: \(series.releasd)\nGenre: \(series.genre.joined(separator: ","))\nCasts: \(series.casts.joined(separator: ","))\nSeasons: \(series.seasons.count)\nProduction: \(series.production)"
        setImageFromNetwork(url: series.thumbnail, imageView: thumbnail)
        if series.seasons.count > 0{
            let season = series.seasons[0]
            seasonBtn.setTitle(season.title, for: .normal)
            selectedEpisodes = season.episodes
            tableView.reloadData()
            print("Episodes \(selectedEpisodes)")
        }
    }
}

extension SeriesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = selectedEpisodes[indexPath.row]
        print("SelectedEpisode Url \(series?.url ?? "").\(episode.id)")
        guard let interceptorWebView =  interceptorWebView else {return }
       
         //KRProgressHUD.show(withMessage: createRandomMessage())
       
        streamProvider.generateVideoSource(interceptorWebView: interceptorWebView, id: episode.id, isMovie: false, mainUrl: series?.url ?? "") { videoSource in
            print("Vidseo Source \(videoSource)")
            KRProgressHUD.dismiss()
            self.openWithVlc(videoSource)
        }/**/
    }
}
extension SeriesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedEpisodes.count
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                return cell
            }()
            
        cell.textLabel?.text = selectedEpisodes[indexPath.row].title
            
        return cell
    }
    
    
}
