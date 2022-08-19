//
//  VideoPlayerController.swift
//  VideoPlayerController
//
//  Created by Dark Matter on 02/10/21.
//

import Foundation
import UIKit
import Player
import VersaPlayer
class VideoPlayerController : UIViewController{
    @IBOutlet weak var playerView: VersaPlayerView!

    @IBOutlet weak var controls: VersaPlayerControls!
   
    @IBOutlet weak var btnClose: UIButton!
    var url : URL? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.use(controls: controls)
        if let url = url {
            let item = VersaPlayerItem(url: url)
            playerView.set(item: item)
            playerView.isFullscreenModeEnabled = true
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.playerView.addGestureRecognizer(tap)
        self.btnClose.isHidden = true
        self.controls.enableMode = .enabled
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        btnClose.isHidden = !btnClose.isHidden
    }
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    func play(url : URL){
      
    }
    static func createVC(_ vc : UIViewController , url : URL) -> UIViewController{
        let videoVC = vc.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerController") as? VideoPlayerController
        videoVC?.url = url
        return videoVC!
    }
}
