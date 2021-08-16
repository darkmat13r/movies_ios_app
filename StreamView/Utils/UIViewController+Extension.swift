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
        var  vlcShareUrl = ""
        if videoSource.sources2.first?.file.count ?? 0 > 0{
           vlcShareUrl =  "vlc-x-callback://x-callback-url/stream?url=\(videoSource.sources2.first?.file ?? "")"
        }else{
            vlcShareUrl =  "vlc-x-callback://x-callback-url/stream?url=\(videoSource.sources1.first?.file ?? "")"
        }
       
        var caption = ""
        videoSource.tracks.forEach { track in
            if   track.kind == "captions"{
                if track.label.caseInsensitiveCompare("english") == .orderedSame{
                    caption = track.file
                }
            }
        }
        if caption.count > 0{
            vlcShareUrl  += "&srt=\(caption)"
        }
        guard let url = URL(string: vlcShareUrl) else {return }
        print("Open Url  2 \(vlcShareUrl)")
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
}
