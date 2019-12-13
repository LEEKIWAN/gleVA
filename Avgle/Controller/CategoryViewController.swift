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

class CategoryViewController: UIViewController, SwipeMenuViewDelegate, SwipeMenuViewDataSource, LeftMenuViewControllerDelegate {
    

    var selectedCategoryIndex: Int?
    var categoryArray: Array<CategoryObject>?
    
    var viewControllerArray: [VideoCollectionViewController] = []
    
    let categoryViewController = self
    
    private lazy var pornstarCollectionViewController: PornstarCollectionViewController = {
        let storyboard = UIStoryboard(name: "PornstarCollectionViewController", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PornstarCollectionViewController") as! PornstarCollectionViewController
        return viewController
    }()
    
    
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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.setNavigtionUI()
        self.setupSideMenu()
        
        for i in 0 ..< categoryArray!.count {
            let storyboard = UIStoryboard.init(name: "VideoCollectionViewController", bundle: nil)
            let videoCollectionViewController = storyboard.instantiateViewController(withIdentifier: "VideoCollectionViewController") as! VideoCollectionViewController
            
            videoCollectionViewController.currentCategory = self.categoryArray![i]
            self.addChild(videoCollectionViewController)
        }
        
        self.swipeMenuView.reloadData()
        self.title = "Categories"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let selectedCategoryIndex = self.selectedCategoryIndex else { return }
        if selectedCategoryIndex == 0 {
            self.swipeMenuView(self.swipeMenuView, willChangeIndexFrom: 0, to: selectedCategoryIndex)
        }
        else {
            self.swipeMenuView.delegate = nil
            self.swipeMenuView.dataSource = nil
            self.swipeMenuView.jump(to: selectedCategoryIndex, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.swipeMenuView.jump(to: selectedCategoryIndex, animated: true)
                self.swipeMenuView(self.swipeMenuView, willChangeIndexFrom: 0, to: selectedCategoryIndex)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.swipeMenuView.delegate = self
                self.swipeMenuView.dataSource = self
            }
        }
        
        self.selectedCategoryIndex = nil
    }
    
    func setNavigtionUI() {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "202020")
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconmonstr-menu-1-64").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onLeftTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconmonstr-magnifier-4-64").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onRightTouched))
    }
    
    
    func setupSideMenu() {
//        SideMenuManager.default.menuFadeStatusBar = false
//
//
        let leftStoryboard = UIStoryboard.init(name: "LeftMenuViewController", bundle: nil)
        let leftMenuViewController = leftStoryboard.instantiateInitialViewController() as! SideMenuNavigationController
        let leftMenu = leftMenuViewController.topViewController as! LeftMenuViewController
        leftMenu.delegate = self

        let rightStoryboard = UIStoryboard.init(name: "RightMenuViewController", bundle: nil)
        let rightMenuViewController = rightStoryboard.instantiateInitialViewController() as! SideMenuNavigationController

        SideMenuManager.default.leftMenuNavigationController = leftMenuViewController
        SideMenuManager.default.rightMenuNavigationController = rightMenuViewController

        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        leftMenuViewController.statusBarEndAlpha = 0
        
        rightMenuViewController.settings = leftMenuViewController.settings
        
        SideMenuManager.default.rightMenuNavigationController!.menuWidth = UIScreen.main.bounds.width
        
        
        
//
    }
    
    
    // MARK: - Event
    @objc func onLeftTouched(sender: UIButton) {
        self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc func onRightTouched(sender: UIButton) {
//        (SideMenuManager.default.rightMenuNavigationController?.children.first as! RightMenuViewController).searchViewController?.searchBar.tex
        self.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
    }
    

    //MARK - SwipeMenuViewDataSource
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return categoryArray!.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return categoryArray![index].name!
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let videoCollectionViewController = children[index]
        videoCollectionViewController.didMove(toParent: self)
        
        return videoCollectionViewController
    }
    
    
    // MARK - SwipeMenuViewDelegate
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        let videoCollectionViewController = children[toIndex] as! VideoCollectionViewController
        
        if videoCollectionViewController.videoArray.count > 0 {
            return
        }
        print(toIndex , "requsetse!!!!!!!!!!!!!!")
        
        videoCollectionViewController.requestVideoList(isFirst: true)
        
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }
    
    //MARK - LeftMenuViewControllerDelegate
    func onCategoryTouched(viewController: UIViewController) {
        self.title = "Categories"
        self.remove(asChildViewController: pornstarCollectionViewController)
        
    }
    
    func onCollectionTouched(viewController: UIViewController) {
        self.title = "Collections"
        self.add(asChildViewController: pornstarCollectionViewController)
    }
    
    
    
    private func add(asChildViewController viewController: UIViewController) {
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
        
    }
  
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    
}
