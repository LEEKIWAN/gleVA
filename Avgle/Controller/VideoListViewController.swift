//
//  VideotableViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 9..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import AFNetworking
import NVActivityIndicatorView
import KafkaRefresh
//import MKDropdownMenu
import ZFPlayer

class VideoListViewController: UIViewController {
    
    let url = "https://api.avgle.com/v1/videos/"
    
    var currentCategory: CategoryObject?
    var videoArray: Array<VideoObject> = []
    var page = 0
    var has_more = true
    
    @IBOutlet weak var tableView: UITableView!
    
    //    let timelineArray: [String] = ["ALL", "Added Today", "Added This Week", "Added This Month"]
    //    let orderArray: [String] = ["Being Watched", "Most Recent", "Most Viewed", "Most Commented", "Top Rated", "Top Favorites", "Longest"]
    //
    //    @IBOutlet weak var dropDownView: MKDropdownMenu!
    
    var urls: [URL] = []
    var player: ZFPlayerController?
    var controlView: ZFPlayerControlView = ZFPlayerControlView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")

        
        self.tableView.bindHeadRefreshHandler({
            self.requestVideoList(isFirst: true)
        }, themeColor: UIColor.lightGray, refreshStyle: .replicatorDot)
        
                
        self.tableView.zf_scrollViewDidStopScrollCallback = { indexPath in
            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.tableView.zf_filterShouldPlayCellWhileScrolled({ indexPath in
            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        })
    }
    
    
    func playTheVideoAtIndexPath(indexPath: IndexPath, scrollToTop: Bool) {
        print("\(indexPath.row) - \(String(describing: videoArray[indexPath.row].title!))")
        self.player!.playTheIndexPath(indexPath, scrollToTop: scrollToTop)
        
        let cell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
        self.controlView.showTitle("", cover: cell.coverImageView!.image, fullScreenMode: .landscape)
    }
    
    
    //MARK: - request
    func requestVideoList(isFirst: Bool) {
        if isFirst {
            self.page = 0
            self.urls.removeAll()
            self.videoArray.removeAll()
            self.tableView.reloadData()
        }
        
        let parameters: [String : String] = ["type" : "public" , "c" : (currentCategory?.CHID)!]
        
//        self.startAnimating()
        
        AFHTTPSessionManager().get("\(url)\(page)", parameters: parameters, progress: nil, success: { (task, responseObject) in
            let dict = responseObject as! Dictionary<String, Any>
            
            let response = dict["response"] as! Dictionary<String, Any>
            let array = response["videos"] as! NSArray
            
            self.has_more = (response["has_more"] != nil)
            
            for item in array {
                let dataJson = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                let video = try! JSONDecoder().decode(VideoObject.self, from: dataJson)
                
                self.videoArray.append(video)
                self.urls.append(URL(string: video.preview_video_url!)!)
            }
            
//            self.stopAnimating()
            self.tableView.headRefreshControl.endRefreshing()
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
            
//            self.player!.playerDidToEnd = { [weak self] asset in
//                self?.player!.stopCurrentPlayingCell()
//            }
            
            
            
        }) { (task, error) in
            
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    
    
    // MARK: - UIViewControllerPreviewingDelegate
    //    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    //
    //        let indexPath = tableView?.indexPathForItem(at: location)
    //
    //        let data = self.videoArray[(indexPath?.row)!]
    //
    //        let storyboard = UIStoryboard.init(name: "VideoPlayViewController", bundle: nil)
    //        let videoPlayViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
    //
    //        videoPlayViewController.videoData = data
    //
    //        return videoPlayViewController
    //
    //    }
    //    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    //        self.present(viewControllerToCommit, animated: false, completion: nil)
    //    }
    //
    //
    //    // MARK: - MKDropdownMenuDataSource
    //
    //    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
    //        return 2
    //    }
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
    //        if component == 0 {
    //            return timelineArray.count
    //        }
    //        else if component == 1 {
    //            return orderArray.count
    //        }
    //
    //
    //        return 0
    //    }
    //
    //    // MARK: - MKDropdownMenuDelegate
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
    //        if component == 0 {
    //            return timelineArray[row]
    //        }
    //        else if component == 1 {
    //            return orderArray[row]
    //        }
    //        return ""
    //    }
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
    //        return NSAttributedString(string: (self.timelineArray[component]), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
    //    }
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForSelectedComponent component: Int) -> NSAttributedString? {
    //        return NSAttributedString(string: (self.timelineArray[component]), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
    //    }
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    //        return NSAttributedString(string: (self.timelineArray[component]), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
    //    }
    //
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, shouldUseFullRowWidthForComponent component: Int) -> Bool {
    //        return false
    //    }
    
    
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForRow row: Int, forComponent component: Int) -> UIColor? {
    //        return nil
    //    }
    //
    //    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForHighlightedRowsInComponent component: Int) -> UIColor? {
    //        return UIColor.gray
    //    }
        
}

extension VideoListViewController: UIScrollViewDelegate {
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


extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        videoPlayWebViewController.modalPresentationStyle = .fullScreen
        self.present(videoPlayWebViewController, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.videoArray.count - 1 == indexPath.row && self.has_more) {
            self.page = self.page + 1
            self.requestVideoList(isFirst: false)
        }
    }
}
