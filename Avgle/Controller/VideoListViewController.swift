//
//  VideoListViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 8..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SwipeMenuViewController
import SideMenu

class VideoListViewController: UIViewController, SwipeMenuViewDelegate, SwipeMenuViewDataSource {

    var selectedCategory: Int?
    var categoryArray: Array<CategoryObject>?
    
    var viewControllerArray: [VideoCollectionViewController] = []
    
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView! {
        didSet {
            swipeMenuView.delegate                        = self
            swipeMenuView.dataSource                      = self
            var options: SwipeMenuViewOptions             = .init()
            options.tabView.additionView.backgroundColor  = UIColor.white
            options.tabView.itemView.textColor            = UIColor.lightGray
            options.tabView.itemView.selectedTextColor    = UIColor.white
            swipeMenuView.options = options
        }
    }
    
    override func viewDidLoad() {
        self.setNavigtionUI()
        self.setupSideMenu()
        
        for i in 0 ..< categoryArray!.count {
            let storyboard = UIStoryboard.init(name: "VideoCollectionViewController", bundle: nil)
            let videoCollectionViewController = storyboard.instantiateViewController(withIdentifier: "VideoCollectionViewController") as! VideoCollectionViewController
            
            
            videoCollectionViewController.currentCategory = self.categoryArray![i]
            self.addChildViewController(videoCollectionViewController)
        }
        
        self.swipeMenuView.reloadData()
        self.swipeMenuView.jump(to: selectedCategory!, animated: false)
    }
    
    
    func setNavigtionUI() {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "202020")
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconmonstr-menu-1-64").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onLeftTouched))
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuFadeStatusBar = false

        let storyboard = UIStoryboard.init(name: "LeftMenuViewController", bundle: nil)
        let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController")  as! LeftMenuViewController

        let leftNavigationController = UISideMenuNavigationController(rootViewController: leftMenuViewController)

        SideMenuManager.default.menuLeftNavigationController = leftNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)

    }
    
    
    // MARK: - Event
    @objc func onLeftTouched(sender: UIButton) {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
        if selectedCategory == currentIndex {
            let videoCollectionViewController = childViewControllers[currentIndex] as! VideoCollectionViewController
            
            
            if videoCollectionViewController.videoArray.count > 0 {
                return
            }
            
            videoCollectionViewController.requestVideoList(isFirst: true)
        }
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        // Codes
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        let videoCollectionViewController = childViewControllers[toIndex] as! VideoCollectionViewController
        
        
        if videoCollectionViewController.videoArray.count > 0 {
            return
        }
        
        videoCollectionViewController.requestVideoList(isFirst: true)
        
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }
    
    
}
