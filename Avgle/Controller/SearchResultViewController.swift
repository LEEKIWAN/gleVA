//
//  SearchResultViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 9. 3..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}
