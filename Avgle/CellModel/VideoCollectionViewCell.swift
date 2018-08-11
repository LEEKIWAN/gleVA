//
//  VideoCollectionViewCell.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 11..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit


class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registedTimeLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var disLikeCountLabel: UILabel!
    
    @IBOutlet weak var HDLabel: UILabel!
    
    override func awakeFromNib() {
        HDLabel.layer.cornerRadius = 3
        
        self.coverImageView.layer.cornerRadius = 3
        
        self.layer.borderColor = UIColor(hexString: "e6e6e6").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        
    }
    
    func setData(data: VideoObject) {
        self.coverImageView.image = nil
        self.indicatorView.startAnimating()
        
        self.coverImageView.setImageWith(URLRequest.init(url: NSURL.init(string: data.preview_url!)! as URL), placeholderImage: nil, success: { (request, response, image) in
            
            self.indicatorView.stopAnimating()
            self.coverImageView.image = image
            
        }) { (request, response, error) in
        }
        
        
        self.titleLabel.text = data.title
        
        
        if data.hd == true {
            self.HDLabel.isHidden = false
        }
        else {
            self.HDLabel.isHidden = true
        }
        
        //
//        let duration: TimeInterval = data.addtime! // 2 minutes, 30 seconds
        
        // registed Time

        //added Time
        
        let addedInterval = Double(data.addtime!)
        
        let addedTime = Date(timeIntervalSince1970: addedInterval)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        
        
        let time = formatter.string(from: addedTime)
        self.registedTimeLabel.text = time
        

        
        // count number
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: data.viewnumber!))
        
        self.playCountLabel.text = "\(formattedNumber!)"
        
        
        // like percentage
        self.likeCountLabel.text = "\(String(describing: data.likes!))"
        
        // dislike percentage
        self.disLikeCountLabel.text = "\(String(describing: data.dislikes!))"
    }
    
    
    
}
