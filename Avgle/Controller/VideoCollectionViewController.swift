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



class VideoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NVActivityIndicatorViewable  {

    let url = "https://api.avgle.com/v1/videos/"

    var currentCategory: CategoryObject?
    var videoArray: Array<VideoObject> = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func requestVideoList() {
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
            self.collectionView.reloadData()
            
        }) { (task, error) in
            
        }
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
        let storyboard = UIStoryboard.init(name: "VideoPlayViewController", bundle: nil)
        let videoPlayViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoCollectionViewController
        
        videoCollectionViewController.currentCategory = self.categoryArray![i]
        self.addChildViewController(videoCollectionViewController)
    }

}
