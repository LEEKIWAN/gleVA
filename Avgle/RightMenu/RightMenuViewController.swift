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
    
    
    var nav: UINavigationController! = nil
    var searchViewController: PYSearchViewController?
    
    var searchResultViewController: SearchResultViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    public func search(text: String) {
        let storyboard = UIStoryboard(name: "SearchResultViewController", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        
        self.searchResultViewController = viewController
        viewController.searchText = text
        searchViewController?.navigationController?.pushViewController(self.searchResultViewController!, animated: true)
    }
    
    func createSearchViewController() {
        searchViewController = PYSearchViewController(hotSearches: searchArray, searchBarPlaceholder: "") { (searchViewController, searchBar, searchText) in
            self.search(text: searchText!)
        }
        
        searchViewController!.backButton.tintColor = UIColor.white
        searchViewController!.searchBar.backgroundColor = UIColor(hexString: "202020")
        
        searchViewController!.view.backgroundColor = UIColor(hexString: "202020")
        
        searchViewController?.hotSearchHeader.textColor = .white
        searchViewController!.hotSearchStyle = .colorfulTag;
        searchViewController!.searchResultShowMode = .embed
        
        searchViewController?.delegate = self
        searchViewController!.searchViewControllerShowMode = .modePush
        
        self.nav = UINavigationController(rootViewController: searchViewController!)
        searchViewController!.navigationController?.navigationBar.barTintColor = UIColor(hexString: "202020")
        searchViewController!.navigationController?.navigationBar.isTranslucent = false
        
        searchViewController?.searchHistoryHeader.textColor = .white
        searchViewController?.searchHistoryStyle = .cell
        
        self.addChild(nav)
        
        view.addSubview(nav.view)
        nav.view.frame = view.bounds
        nav.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    //MARK: - PYSearchViewControllerDelegate
    
    func didClickBack(_ searchViewController: PYSearchViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

