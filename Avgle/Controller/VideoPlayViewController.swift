//
//  VideoPlayViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 11..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import ZFPlayer

class VideoPlayViewController: UIViewController {

    var videoData: VideoObject?
    var player: ZFPlayerController?
    
    var assetURL: URL?
    
    let controlView = ZFPlayerControlView()
    let playerManager = ZFAVPlayerManager()

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if (self.player?.isFullScreen)! {
            return .lightContent;
        }
        return .default;
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.player!.isStatusBarHidden;
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var shouldAutorotate: Bool {
        return (self.player?.shouldAutorotate)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = ZFPlayerController.player(withPlayerManager: playerManager, containerView: self.containerView!);
        self.player?.controlView = self.controlView
        
        self.titleLabel.text = videoData?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = videoData?.title
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.player?.isViewControllerDisappear = false;
        
        self.assetURL = URL(string: (videoData?.preview_video_url)!)
        self.player?.assetURL = self.assetURL!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.player?.playTheIndex(0)
        self.controlView.showTitle("", coverURLString: videoData?.preview_url, fullScreenMode: .landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.isViewControllerDisappear = true;
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if (self.player?.isFullScreen)! {
            return .landscape;
        }
        return .portrait;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        self.player?.currentPlayerManager.isMuted = !self.player?.currentPlayerManager.isMuted
//        self.player?.currentPlayerManager.isMuted = !(self.player?.currentPlayerManager.isMuted)
    }

    
    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

