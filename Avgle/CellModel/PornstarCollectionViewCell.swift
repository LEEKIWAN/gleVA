//
//  PornstarCollectionViewCell.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 19..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

class PornstarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var playCountLabel: UILabel!
    
    
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
        
        self.videoCountLabel.setTitle("\(data.total_videos!)", for: .normal)
        self.categoryNameLabel.text = data.name
    }
    
}
