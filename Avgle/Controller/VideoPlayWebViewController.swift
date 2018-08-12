//
//  VideoPlayWebViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 12..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import WebKit

class VideoPlayWebViewController: UIViewController {

    var videoData: VideoObject?
    
//    let url = URL(string: "https://avgle.com/embed/f13e55b73a8cf429bbc1")
    
    @IBOutlet weak var webView: WKWebView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = videoData?.title
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        

        
        
        let video_url = videoData?.embedded_url
        
        if let encoded  = video_url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded){
            
            webView.load(URLRequest(url: url))

        }
        
    }

    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

