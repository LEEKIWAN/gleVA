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
        self.coverImageView.layer.cornerRadius = 3
        
        self.layer.borderColor = UIColor(hexString: "e6e6e6").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
    }
    
    
    func setData(data: CollectionObject) {
        self.coverImageView.image = nil
        self.indicatorView.startAnimating()
        
        self.coverImageView.setImageWith(URLRequest.init(url: NSURL.init(string: data.cover_url!)! as URL), placeholderImage: nil, success: { (request, response, image) in
            
            self.indicatorView.stopAnimating()
            self.coverImageView.image = image
        }) { (request, response, error) in
            
        }
        
        
        self.playCountLabel.text = "\(data.total_views!)"
        self.videoCountLabel.setTitle("\(data.video_count!)", for: .normal)
        self.categoryNameLabel.text = data.title
    }
    
}
