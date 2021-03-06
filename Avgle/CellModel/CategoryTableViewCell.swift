//
//  CategoryTableViewCell.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 11..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

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
        
        let total_videos = data.total_videos
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:total_videos!))
        
    
        self.videoCountLabel.setTitle("\(formattedNumber!)", for: .normal)
        self.categoryNameLabel.text = data.name
    }
}
