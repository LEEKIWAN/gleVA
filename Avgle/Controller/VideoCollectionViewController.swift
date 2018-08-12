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


class VideoCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerPreviewingDelegate, NVActivityIndicatorViewable  {

    let url = "https://api.avgle.com/v1/videos/"

    var currentCategory: CategoryObject?
    var videoArray: Array<VideoObject> = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
        
        self.collectionView.bindHeadRefreshHandler({
            self.requestVideoList(isFirst: true)
            
        }, themeColor: UIColor.lightGray, refreshStyle: .replicatorDot)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func requestVideoList(isFirst: Bool) {
        if isFirst {
            self.videoArray.removeAll()
            self.collectionView.reloadData()
        }
        
        let parameters: [String : String] = ["type" : "public" , "c" : (currentCategory?.CHID)!]
        
        self.startAnimating()
        AFHTTPSessionManager().get("\(url)0", parameters: parameters, progress: nil, success: { (task, responseObject) in
            let dict = responseObject as! Dictionary<String, Any>
            
            let response = dict["response"] as! Dictionary<String, Any>
            let array = response["videos"] as! NSArray
            
            print(response)
            
            for item in array {
                let dataJson = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                let video = try! JSONDecoder().decode(VideoObject.self, from: dataJson)
                
                self.videoArray.append(video)
            }
            
            self.stopAnimating()
            self.collectionView.headRefreshControl.endRefreshing()
            self.collectionView.reloadData()
            
        }) { (task, error) in
            
        }
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
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
        
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.videoArray[indexPath.row]
        
        let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoIdentifier", for: indexPath) as! VideoCollectionViewCell
        
        videoCell.setData(data: data)
        
        return videoCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = self.videoArray[indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "VideoPlayWebViewController", bundle: nil)
        let videoPlayWebViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayWebViewController") as! VideoPlayWebViewController
        
        videoPlayWebViewController.videoData = data
        
        self.navigationController?.pushViewController(videoPlayWebViewController, animated: true)
        
//        self.presentingViewController?.navigationController?.pushViewController(videoPlayWebViewController, animated: true)
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.size.width - 30
        let height = width * 0.78
        return CGSize(width: width, height: height)
        
    }

}
