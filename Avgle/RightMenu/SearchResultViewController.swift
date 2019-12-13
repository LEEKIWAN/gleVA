//
//  SearchResultViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 9. 3..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import AFNetworking
import NVActivityIndicatorView

class SearchResultViewController: UIViewController {

    var searchText: String?
    var searchBar = UISearchBar()
    
    var videoArray: Array<VideoObject> = []
    let url = "https://api.avgle.com/v1/search/"
    var page = 0
    var has_more = true
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.requestSearchList()
        
//        self.collectionView.bindHeadRefreshHandler({
//            self.requestVideoList(isFirst: true)
//        }, themeColor: UIColor.lightGray, refreshStyle: .replicatorDot)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    
    func setupNavigationBar() {
        let searchBarContainer = SearchBarContainerView(customSearchBar: self.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
    }
    
    
    func requestSearchList() {
        AFHTTPSessionManager().get("\(url)\(searchText!)/\(page)", parameters: nil, progress: nil, success: { (task, responseObject) in
           let dict = responseObject as! Dictionary<String, Any>
            
            let response = dict["response"] as! Dictionary<String, Any>
            let array = response["videos"] as! NSArray
            
            self.has_more = (response["has_more"] != nil)
            
            for item in array {
                let dataJson = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                let video = try! JSONDecoder().decode(VideoObject.self, from: dataJson)
                
                self.videoArray.append(video)
            }
            
            
//            self.stopAnimating()
//            self.collectionView.headRefreshControl.endRefreshing()
//            self.collectionView.reloadData()
            
        }) { (task, error) in
            
        }
    }
}


class SearchBarContainerView: UIView {

    let searchBar: UISearchBar


    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)

//        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.barTintColor = UIColor.white
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.searchTextField.isEnabled = false
        addSubview(searchBar)
    }
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}

