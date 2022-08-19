//
//  UIViewController+Extension.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import UIKit
extension UIViewController{
    func openWithVlc(_ videoSource : ViewSource){
        var  url = ""
        var mp4Source  = videoSource.sources.filter({ source in
            source.type == "mp4"
        })
        if videoSource.sources.isEmpty{
            showSimpleAlert(msg: "Unable to find video source")
            return
        }
        if mp4Source.isEmpty{
            url = videoSource.sources[0].file
        }else{
            url = mp4Source[0].file
        }
    
       
        var vlcShareUrl = "vlc-x-callback://x-callback-url/stream?url=\(url)"
       
        var caption = ""
        videoSource.tracks.forEach { track in
            if   track.kind == .captions{
                if track.label.lowercased().contains("english"){
                    caption = track.file
                }
            }
        }
        if caption.isEmpty == false{
            vlcShareUrl  += "&sub=\(caption)"
        }
        guard let url = URL(string: vlcShareUrl) else {return }
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }else {
            showSimpleAlert(msg: "Please install vlc to view video")
        }
        
    }
    func showSimpleAlert(msg : String) {
        let alert = UIAlertController(title: "Alert", message: msg,         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            
            }))
           
            self.present(alert, animated: true, completion: nil)
        }
    
    
    func openMovieDetail(_ movie : Movie){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
        vc.movie = movie
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTvSeriesDetails(_ series : TvSeries){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
        vc.series = series
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

