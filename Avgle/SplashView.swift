//
//  LaunchScreen.swift
//  HowlTalk
//
//  Created by 이기완 on 09/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import SKSplashView

class SplashView: UIViewController, SKSplashDelegate {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var splashView: SKSplashView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashAnimation()
    }
    
    func splashAnimation() {
        let splashIcon = SKSplashIcon(image: #imageLiteral(resourceName: "logo"), animationType: .bounce)
        splashIcon?.iconSize = CGSize(width: 140, height: 66)
        self.splashView = SKSplashView(splashIcon: splashIcon, animationType: .none)
        self.view.addSubview(self.splashView!)
        
        self.splashView?.delegate = self
        self.splashView?.animationDuration = 2
        self.splashView?.startAnimation()
    }
    
    
    func splashViewDidEndAnimating(_ splashView: SKSplashView!) {
        let storyboard = UIStoryboard.init(name: "FirstViewController", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainViewController
    }
    
    func splashView(_ splashView: SKSplashView!, didBeginAnimatingWithDuration duration: Float) {
        
        
    }

}
