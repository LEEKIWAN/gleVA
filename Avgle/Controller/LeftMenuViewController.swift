//
//  LeftMenuViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 12..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SideMenu


protocol LeftMenuViewControllerDelegate {
    func onCollectionTouched(viewController: UIViewController)
    func onCategoryTouched(viewController: UIViewController)
}

class LeftMenuViewController: UIViewController {

    var delegate: LeftMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func onCategoryTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.onCategoryTouched(viewController: self)
        
    }
    
    
    
    @IBAction func onCollectionTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.onCollectionTouched(viewController: self)
        
        
    }
}
