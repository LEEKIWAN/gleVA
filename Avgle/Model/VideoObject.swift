//
//  VideoObject.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 9..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

class VideoObject: Codable {
    var title: String?
    var keyword: String?
    var channel: String?
    var duration: Float?
    var framerate: Float?
    var hd: Bool?
    var addtime: Int?
    var viewnumber: Int?
    var likes: Int?
    var dislikes: Int?
    var video_url: String?
    var embedded_url: String?
    var preview_url: String?
    var preview_video_url: String?
    var vid: String?
    var uid: String?
    
    var `private`: Bool?

}

