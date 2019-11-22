//
//  VideoCollectionViewController.swift
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

class VideoCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerPreviewingDelegate, NVActivityIndicatorViewable, UIScrollViewDelegate {

    let url = "https://api.avgle.com/v1/videos/"

    var currentCategory: CategoryObject?
    var videoArray: Array<VideoObject> = []
    var page = 0
    var has_more = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    let timelineArray: [String] = ["ALL", "Added Today", "Added This Week", "Added This Month"]
//    let orderArray: [String] = ["Being Watched", "Most Recent", "Most Viewed", "Most Commented", "Top Rated", "Top Favorites", "Longest"]
//
//    @IBOutlet weak var dropDownView: MKDropdownMenu!
    
    var urls: [URL] = []
    var player: ZFPlayerController?
    var controlView: ZFPlayerControlView = ZFPlayerControlView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
        
        self.collectionView.bindHeadRefreshHandler({
            self.requestVideoList(isFirst: true)
        }, themeColor: UIColor.lightGray, refreshStyle: .replicatorDot)
        

        let playerManager = ZFAVPlayerManager()
        
        self.player = ZFPlayerController.player(with: self.collectionView, playerManager: playerManager, containerViewTag: 100)
        
        self.player?.controlView = self.controlView;
        self.player?.assetURLs = self.urls;
        self.player?.shouldAutoPlay = true;
        
        
//        self.player?.orientationWillChange = { player, isFullScreen in
//            self.setNeedsStatusBarAppearanceUpdate()
//            self.collectionView.scrollsToTop = !isFullScreen
//        }
//
//        self.player?.playerDidToEnd = { asset in
//            if (self.player!.playingIndexPath?.row)! < self.urls.count - 1 && !self.player!.isFullScreen {
//                let indexPath = IndexPath(row: (self.player?.playingIndexPath?.row)! + 1, section: 0)
//                self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: true)
//            } else if self.player!.isFullScreen {
//                self.player!.enterFullScreen(false, animated: true)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(self.player!.orientationObserver.duration * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    self.player!.stopCurrentPlayingCell()
//                })
//            }
//        }

        
//        self.collectionView.zf_scrollViewDidStopScrollCallback = { indexPath in
//            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
//        }

//        self.dropDownView.dataSource = self;
//        self.dropDownView.delegate = self;
//
//
//        self.dropDownView.dropdownBackgroundColor = UIColor(hexString: "202020")
//        self.dropDownView.selectedComponentBackgroundColor = UIColor(hexString: "202020")
//
//        self.dropDownView.tintColor = UIColor.white
//
//        self.dropDownView.rowSeparatorColor = UIColor.darkGray
//        self.dropDownView.componentSeparatorColor = UIColor(hexString: "202020")
//
//        self.dropDownView.backgroundDimmingOpacity = 0.05
//
//        self.dropDownView.dropdownShowsTopRowSeparator = false
//        self.dropDownView.dropdownShowsBottomRowSeparator = false
//        self.dropDownView.dropdownShowsBorder = true
//        self.dropDownView.dropdownBouncesScroll = false
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.zf_filterShouldPlayCellWhileScrolled({ indexPath in
            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        })
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
    }
    
    func playTheVideoAtIndexPath(indexPath: IndexPath, scrollToTop: Bool) {
        self.player?.playTheIndexPath(indexPath, scrollToTop: scrollToTop)
        let data = self.videoArray[indexPath.row]

        self.controlView.showTitle(data.title, coverURLString: data.preview_url, fullScreenMode: .landscape)
    }
    
    
    //MARK: - request
    func requestVideoList(isFirst: Bool) {
        if isFirst {
            self.page = 0
            self.urls.removeAll()
            self.videoArray.removeAll()
            self.collectionView.reloadData()
        }
        
        let parameters: [String : String] = ["type" : "public" , "c" : (currentCategory?.CHID)!]
        
        self.startAnimating()
        
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
            
            self.stopAnimating()
            self.collectionView.headRefreshControl.endRefreshing()
            self.collectionView.reloadData()
            
        }) { (task, error) in
            
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
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
    
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = collectionView?.indexPathForItem(at: location)
        
        let data = self.videoArray[(indexPath?.row)!]
        
        let storyboard = UIStoryboard.init(name: "VideoPlayViewController", bundle: nil)
        let videoPlayViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController

        videoPlayViewController.videoData = data
        
        return videoPlayViewController
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.present(viewControllerToCommit, animated: false, completion: nil)
        
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.videoArray[indexPath.row]
        let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoIdentifier", for: indexPath) as! VideoCollectionViewCell        
        
        videoCell.setData(data: data)
        videoCell.playHandler = {
            
             self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
        }
        
        
        return videoCell;
    }
    
    // MARK : - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = self.videoArray[indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "VideoPlayWebViewController", bundle: nil)
        let videoPlayWebViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayWebViewController") as! VideoPlayWebViewController
        
        videoPlayWebViewController.videoData = data
        
        self.present(videoPlayWebViewController, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (self.videoArray.count - 1 == indexPath.row && self.has_more) {
            self.page = self.page + 1
            self.requestVideoList(isFirst: false)
        }
    }
    
    // MARK : - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let orientation = UIDevice.current.orientation
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation == .portrait {
            let width = collectionView.size.width - 30
            let height = width * 0.78
            return CGSize(width: width, height: height)
        }
        else {
            let padding: CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            
            let width = collectionViewSize / 2
            let height = width * 0.78
            
            return CGSize(width: width, height: height)
        }
    }

    
    //MARK: - VideoCollectionViewCellDelegate
    func onPlayTouched(cell: UICollectionViewCell) {
    }
    
    
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
