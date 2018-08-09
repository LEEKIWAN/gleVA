//
//  VideoCollectionViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 9..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import AFNetworking

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registedTimeLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var likePercentageLabel: UILabel!
    
    @IBOutlet weak var HDLabel: UILabel!
    
    override func awakeFromNib() {
        HDLabel.layer.cornerRadius = 3
    }
    
    func setData(data: VideoObject) {
        self.coverImageView.image = nil
        self.indicatorView.startAnimating()
        
        self.coverImageView.setImageWith(URLRequest.init(url: NSURL.init(string: data.preview_url!)! as URL), placeholderImage: nil, success: { (request, response, image) in
            
            self.indicatorView.stopAnimating()
            self.coverImageView.image = image
            
        }) { (request, response, error) in
            
        }
        
//        self.
        
//        self.videoCountLabel.setTitle("\(data.total_videos!)", for: .normal)
//        self.categoryNameLabel.text = data.name
    }
}

class VideoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let url = "https://api.avgle.com/v1/videos/"

    var currentCategory: CategoryObject?
    var videoArray: Array<VideoObject> = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        0?type=public&c=1
        
    }
    
    func requestVideoList() {
        let parameters: [String : String] = ["type" : "public" , "c" : "1"]
        
        
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
    

}
