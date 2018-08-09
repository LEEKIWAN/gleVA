//
//  ViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 3..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import AFNetworking

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        videoCountLabel.layer.cornerRadius = videoCountLabel.frame.size.height / 2
    }
    
    func setData(data: CategoryObject) {
        self.coverImageView.image = nil
        self.indicatorView.startAnimating()
        
        self.coverImageView.setImageWith(URLRequest.init(url: NSURL.init(string: data.cover_url!)! as URL), placeholderImage: nil, success: { (request, response, image) in
        
            self.indicatorView.stopAnimating()
            self.coverImageView.image = image
        }) { (request, response, error) in
            
        }
        
        self.coverImageView.setImageWith(NSURL.init(string: data.cover_url!)! as URL)
        self.videoCountLabel.setTitle("\(data.total_videos!)", for: .normal)
        self.categoryNameLabel.text = data.name
    }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categoryArray: Array<CategoryObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestCategoryList()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
            
            self.tableView.reloadData()
        }) { (task, error) in
            
        }
    }
    
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.categoryArray[indexPath.row]
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryIdentifier", for: indexPath) as! CategoryTableViewCell
        
        tableViewCell.setData(data: data)
        
        return tableViewCell;
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard.init(name: "VideoListViewController", bundle: nil)
        let videoListViewController = storyboard.instantiateViewController(withIdentifier: "VideoListViewController") as! VideoListViewController
        videoListViewController.categoryArray = self.categoryArray
        videoListViewController.selectedCategory = indexPath.row
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = videoListViewController
        
    }
}

