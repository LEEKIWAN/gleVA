//
//  LeftMenuViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 12..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SideMenu

class LeftMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCollectionTouched(_ sender: Any) {
        
//        self.dismiss(animated: true) {
//
//            self.presentingViewController?.present(pornstarCollectionViewController, animated: true, completion: nil)
//            self.presentedViewController?.present(pornstarCollectionViewController, animated: true, completion: nil)
//        }
        
        let storyboard = UIStoryboard.init(name: "PornstarCollectionViewController", bundle: nil)
        let pornstarCollectionViewController = storyboard.instantiateViewController(withIdentifier: "PornstarCollectionViewController") as! PornstarCollectionViewController
        
        self.present(pornstarCollectionViewController, animated: true, completion: nil)
        
        
    }
}
