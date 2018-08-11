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


    var player: ZFPlayerController?
    
    var assetURL: URL?
    
    let controlView = ZFPlayerControlView()
    let playerManager = ZFAVPlayerManager()

    @IBOutlet weak var containerView: UIView!
    
//    @property (nonatomic, strong) ZFPlayerController *player;
//    @property (nonatomic, strong) ZFPlayerControlView *controlView;
//    @property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
//    @property (nonatomic, strong) NSURL *assetURL;

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
        
        self.assetURL = URL(string: "https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4")
        
        self.player?.assetURL = self.assetURL!;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.player?.isViewControllerDisappear = false;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.player?.playTheIndex(0)
        self.controlView.showTitle("saef", coverURLString: "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240", fullScreenMode: .landscape)
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
    
    
}

