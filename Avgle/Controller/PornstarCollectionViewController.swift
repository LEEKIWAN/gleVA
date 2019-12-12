//
//  PornstarCollectionViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 18..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import AFNetworking
import NVActivityIndicatorView

class PornstarCollectionViewController: UIViewController, NVActivityIndicatorViewable, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var page = 0
    var has_more = true
    let url = "https://api.avgle.com/v1/collections/"
    
    var collectionArray: Array<CollectionObject> = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestCollectionList(isFirst: true)
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            
        } else {
            
        }
        
        flowLayout.invalidateLayout()
    }
    
    
    //MARK: - reqeust
    func requestCollectionList(isFirst: Bool) {
        if isFirst {
            self.page = 0
            self.collectionArray.removeAll()
            self.collectionView.reloadData()
        }
        
        
        self.startAnimating()
        
        AFHTTPSessionManager().get("\(url)\(page)", parameters: nil, progress: nil, success: { (task, responseObject) in
            let dict = responseObject as! Dictionary<String, Any>
            
            let response = dict["response"] as! Dictionary<String, Any>
            let array = response["collections"] as! NSArray
            
            print(response)
            
            if "\(response["has_more"]!)" == "1" {
                self.has_more = true
            }
            else {
                self.has_more = false
            }
            
            for item in array {
                let dataJson = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                let collection = try! JSONDecoder().decode(CollectionObject.self, from: dataJson)
                
                self.collectionArray.append(collection)
            }
            
            self.stopAnimating()
            self.collectionView.reloadData()
            
        }) { (task, error) in
            
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.collectionArray[indexPath.row]
        
        let pornstarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PornstarCollectionViewCell", for: indexPath) as! PornstarCollectionViewCell
        
        pornstarCell.setData(data: data)
        
        return pornstarCell;
    }
    
    // MARK : - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let data = self.collectionArray[indexPath.row]
        
//        let storyboard = UIStoryboard.init(name: "VideoPlayWebViewController", bundle: nil)
//        let videoPlayWebViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayWebViewController") as! VideoPlayWebViewController
//
//        videoPlayWebViewController.videoData = data
//
//        self.present(videoPlayWebViewController, animated: false, completion: nil)
        
        //        self.navigationController?.pushViewController(videoPlayWebViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (self.collectionArray.count - 1 == indexPath.row && self.has_more) {
            self.page = self.page + 1
            self.requestCollectionList(isFirst: false)
        }
    }
    
    // MARK : - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding

        let width = collectionViewSize / 2
        let height = width * 0.5625
        
        return CGSize(width: width, height: height)
        
    }
    

}
