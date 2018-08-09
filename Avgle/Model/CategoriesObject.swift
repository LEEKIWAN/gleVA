//
//  CategoryModel.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 6..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

//class CategoriesObject: Codable {
//
//}

class CategoryObject: Codable {
    var CHID: String?
    var name: String?
    var slug: String?
    var total_videos: Int?
    var shortname: String?
    var category_url: String?
    var cover_url: String?
}
