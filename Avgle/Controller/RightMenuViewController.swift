//
//  RightMenuViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 27..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import PYSearch


class RightMenuViewController: UIViewController, PYSearchViewControllerDelegate {
    
    let searchArray: [String] = ["三上悠亜", "高橋しょう子", "波多野結衣", "橋本ありな", "天使もえ", "小島みなみ", "桜空もも", "水卜さくら", "松本菜奈実", "戸田真琴", "明里つむぎ", "澁谷果歩", "あやみ旬果", "佐々木あき", "椎名そら", "飛鳥りん", "若菜奈央", "星奈あい", "上原亜衣", "大槻ひびき", "凰かなめ", "愛音まりあ", "栄川乃亜", "佐々木あき", "丘咲エミリ", "篠田あゆみ", "有賀ゆあ", "水野朝陽", "吉沢明歩", "紗倉まな", "姫川ゆうな", "西川ゆい", "AIKA", "JULIA", "マンコ図鑑", "ミラー号", "中文字幕", "日本VR", "洋物VR"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchViewController = PYSearchViewController(hotSearches: searchArray, searchBarPlaceholder: "") { (searchViewController, searchBar, searchText) in
//            [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
        }
        
        searchViewController!.backButton.tintColor = UIColor.white
        searchViewController!.searchBar.backgroundColor = UIColor(hexString: "202020")
        searchViewController!.view.backgroundColor = UIColor(hexString: "202020")
        
        searchViewController!.hotSearchStyle = .colorfulTag;
        searchViewController!.searchResultShowMode = .embed
        searchViewController!.searchViewControllerShowMode = .modePush
        
        searchViewController?.delegate = self
        
        let nav = UINavigationController(rootViewController: searchViewController!)
        
        
        searchViewController!.navigationController?.navigationBar.barTintColor = UIColor(hexString: "202020")
        searchViewController!.navigationController?.navigationBar.isTranslucent = false
        
        
        self.addChildViewController(nav)
        
        view.addSubview(nav.view)
        nav.view.frame = view.bounds
        nav.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        nav.didMove(toParentViewController: self)
    
        
    }
    
    
    //MARK: - PYSearchViewControllerDelegate
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didClickBack(_ searchViewController: PYSearchViewController!) {
         self.dismiss(animated: true, completion: nil)
    }
}
