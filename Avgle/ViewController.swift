//
//  ViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 3..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import AFNetworking

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UIButton!
}


class ViewController: UIViewController, UICollectionViewDataSource {
  
    var categoryArray: Array<CategoryObject> = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestCategoryList()
    }

    func requestCategoryList() {
        AFHTTPSessionManager().get("https://api.avgle.com/v1/categories", parameters: nil, progress: nil, success: { (task, responseObject) in
            let dict = responseObject as! Dictionary<String, Any>
            
            let response = dict["response"] as! Dictionary<String, Any>
            let array = response["categories"] as! NSArray
            
            for item in array {
                let dataJson = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                let category = try! JSONDecoder().decode(CategoryObject.self, from: dataJson)
                
                self.categoryArray.append(category)
            }
            
            self.collectionView.reloadData()
        }) { (task, error) in
            
        }
    }
    
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.categoryArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        
//        cell.categoryNameLabel.text = data.name
        cell.backgroundColor = UIColor.blue
        
        return cell
    }

}

