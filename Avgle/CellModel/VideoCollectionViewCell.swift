//
//  VideoCollectionViewCell.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 11..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import MarqueeLabel
import ZFPlayer


protocol VideoCollectionViewCellDelegate {
    func onPlayTouched(cell: UICollectionViewCell)
}


class VideoCollectionViewCell: UICollectionViewCell {
    
    var delegate: VideoCollectionViewCellDelegate?
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var registedTimeLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var disLikeCountLabel: UILabel!
    
    @IBOutlet weak var HDLabel: UILabel!
    
    @IBOutlet weak var videoContainerView: UIView!
    
    var player: ZFPlayerController?
    let controlView = ZFPlayerControlView()
    let playerManager = ZFAVPlayerManager()
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        self.HDLabel.layer.cornerRadius = 3
        self.coverImageView.layer.cornerRadius = 3
        
        self.layer.borderColor = UIColor(hexString: "e6e6e6").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
        
        if self.player == nil {
            self.player = ZFPlayerController.player(withPlayerManager: playerManager, containerView: self.videoContainerView!);
            self.player?.controlView = self.controlView
            self.controlView.isUserInteractionEnabled = false
            
        }
    }
    
    func setData(data: VideoObject) {
        self.coverImageView.image = nil
        self.indicatorView.startAnimating()
        
        self.coverImageView.setImageWith(URLRequest.init(url: NSURL.init(string: data.preview_url!)! as URL), placeholderImage: nil, success: { (request, response, image) in
            self.indicatorView.stopAnimating()
            self.coverImageView.image = image
            
        }) { (request, response, error) in
        }
        
        //title marquee
        self.titleLabel.text = data.title
        self.titleLabel.speed = .rate(50)
        
        self.titleLabel.animationCurve = .easeInOut
        self.titleLabel.animationDelay = 2.5
        self.titleLabel.trailingBuffer = 30.0
        self.titleLabel.restartLabel()
        
        
        // hd
        if data.hd == true {
            self.HDLabel.isHidden = false
        }
        else {
            self.HDLabel.isHidden = true
        }
     
        //added Time
        
        let addedInterval = Double(data.addtime!)
        let addedTime = Date(timeIntervalSince1970: addedInterval)
        let ageText = self.timeAgoStringFromDate(date: addedTime)
        self.registedTimeLabel.text = ageText
    
        
        // count number
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: data.viewnumber!))
        
        self.playCountLabel.text = "\(formattedNumber!)"
        
        
        // like percentage
        self.likeCountLabel.text = "\(String(describing: data.likes!))"
        
        // dislike percentage
        self.disLikeCountLabel.text = "\(String(describing: data.dislikes!))"
        
        // video
        self.videoContainerView.isHidden = true
        self.playerManager.stop()
        self.player?.assetURL = URL(string: (data.preview_video_url)!)!
        self.controlView.showTitle("", coverURLString: data.preview_url, fullScreenMode: .landscape)
    }
    
    func timeAgoStringFromDate(date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let now = Date()
        
        let calendar = NSCalendar.current
        let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        let components = calendar.dateComponents(components1, from: date, to: now)
        
        if components.year ?? 0 > 0 {
            formatter.allowedUnits = .year
        } else if components.month ?? 0 > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth ?? 0 > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day ?? 0 > 0 {
            formatter.allowedUnits = .day
        } else if components.hour ?? 0 > 0 {
            formatter.allowedUnits = [.hour]
        } else if components.minute ?? 0 > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        
        guard let timeString = formatter.string(for: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
    
    
    @IBAction func onPreviewTouched(_ sender: UIButton) {
        self.videoContainerView.isHidden = false
        self.player?.playTheIndex(0)

    }
    
}
