//
//  PornstarCollectionViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 18..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

class PornstarCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}
