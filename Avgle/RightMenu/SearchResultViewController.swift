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
import ZFPlayer

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    var searchText: String?
    var searchBar = UISearchBar()
    
    
    var videoArray: Array<VideoObject> = []
    let url = "https://api.avgle.com/v1/search/"
    var page = 0
    var has_more = true
    
    var urls: [URL] = []
    var player: ZFPlayerController?
    var controlView: ZFPlayerControlView = ZFPlayerControlView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
        self.searchBar.searchTextField.text = searchText!
        self.setupNavigationBar()
        self.requestSearchList(isFirst: true)
        
        self.tableView.zf_scrollViewDidStopScrollCallback = { indexPath in
            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.tableView.zf_filterShouldPlayCellWhileScrolled({ indexPath in
            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        })
    }
    
    func setupNavigationBar() {
        let searchBarContainer = SearchBarContainerView(customSearchBar: self.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
    }
    
    func playTheVideoAtIndexPath(indexPath: IndexPath, scrollToTop: Bool) {
//        print("\(indexPath.row) - \(String(describing: videoArray[indexPath.row].title!))")
//        
//        self.player!.playTheIndexPath(indexPath, scrollToTop: scrollToTop)
//        
//        let cell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
//        self.controlView.showTitle("", cover: cell.coverImageView!.image, fullScreenMode: .landscape)
    }
    
    func requestSearchList(isFirst: Bool) {
        if isFirst {
            self.page = 0
            self.videoArray.removeAll()
            self.tableView.reloadData()
        }
        
        let encodedString = "\(url)\(searchText!)/\(page)"
        let encodedURL = encodedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
//        self.startAnimating()
        
        AFHTTPSessionManager().get(encodedURL!, parameters: nil, progress: nil, success: { (task, responseObject) in
            let dict = responseObject as! Dictionary<String, Any>
            
            let response = dict["response"] as! Dictionary<String, Any>
            let array = response["videos"] as! NSArray
            
            self.has_more = response["has_more"] as! Bool
            self.totalCountLabel.text = String(response["total_videos"] as! Int)
            for item in array {
                let dataJson = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                let video = try! JSONDecoder().decode(VideoObject.self, from: dataJson)
                
                self.videoArray.append(video)
            }
            print(dict)
            
//            self.stopAnimating()
            self.tableView.reloadData()
            
            let playerManager = ZFAVPlayerManager()
            self.player = ZFPlayerController.player(with: self.tableView, playerManager: playerManager, containerViewTag: 100)
            self.player!.controlView = self.controlView;
            self.player!.assetURLs = self.urls;
            self.player!.shouldAutoPlay = true;
            
            self.player!.isMuted = true
            self.player!.playerDisapperaPercent = 0.8
            self.player!.allowOrentitaionRotation = false
            self.player!.disableGestureTypes = .all
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.zf_filterShouldPlayCellWhileScrolled({ indexPath in
                    self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
                })
            }
            
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


extension SearchResultViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}


extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UItableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.videoArray[indexPath.row]
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        videoCell.setData(data: data)
        
        videoCell.playHandler = {
            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        }
        
        
        return videoCell;
    }
    
    // MARK : - UItableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.videoArray[indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "VideoPlayWebViewController", bundle: nil)
        let videoPlayWebViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayWebViewController") as! VideoPlayWebViewController
        
        videoPlayWebViewController.videoData = data
        
        self.present(videoPlayWebViewController, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.videoArray.count - 1 == indexPath.row && self.has_more) {
            self.page = self.page + 1
            self.requestSearchList(isFirst: false)
        }
    }
}
