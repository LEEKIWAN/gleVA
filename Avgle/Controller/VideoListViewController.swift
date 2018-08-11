//
//  VideoListViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 8..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SwipeMenuViewController


class VideoListViewController: UIViewController, SwipeMenuViewDelegate, SwipeMenuViewDataSource {

    var selectedCategory: Int?
    var categoryArray: Array<CategoryObject>?
    
    var viewControllerArray: [VideoCollectionViewController] = []
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView! {
        didSet {
            swipeMenuView.delegate                        = self
            swipeMenuView.dataSource                      = self
//            var options: SwipeMenuViewOptions             = .init()
//            options.tabView.additionView.backgroundColor  = UIColor.blue
//            options.tabView.itemView.textColor            = UIColor.darkGray
//            options.tabView.itemView.selectedTextColor    = UIColor.white
//            swipeMenuView.options = options
        }
    }
    
    override func viewDidLoad() {
        
        for i in 0 ..< categoryArray!.count {
            let storyboard = UIStoryboard.init(name: "VideoCollectionViewController", bundle: nil)
            let videoCollectionViewController = storyboard.instantiateViewController(withIdentifier: "VideoCollectionViewController") as! VideoCollectionViewController

            videoCollectionViewController.currentCategory = self.categoryArray![i]
            self.addChildViewController(videoCollectionViewController)
        }
        
        
        self.swipeMenuView.reloadData()
        
        
        self.swipeMenuView.jump(to: selectedCategory!, animated: false)
    }
    
    
    //MARK - SwipeMenuViewDataSource
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return categoryArray!.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return categoryArray![index].name!
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        
        let videoCollectionViewController = childViewControllers[index]
        videoCollectionViewController.didMove(toParentViewController: self)
        
        
        return videoCollectionViewController
    }
    
    
    // MARK - SwipeMenuViewDelegate
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        // Codes
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        // Codes
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        
        let videoCollectionViewController = childViewControllers[toIndex] as! VideoCollectionViewController
        if videoCollectionViewController.videoArray.count > 0 {
            return
        }
        
        videoCollectionViewController.requestVideoList()
        
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }
    
    
}
