//
//  VideoListViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 8..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SideMenu

class CategoryViewController: UIViewController, LeftMenuViewControllerDelegate {
    

    var selectedCategory: Int?
    var categoryArray: Array<CategoryObject>?
    
    var viewControllerArray: [VideoCollectionViewController] = []
    
    let categoryViewController = self
    
    private lazy var pornstarCollectionViewController: PornstarCollectionViewController = {
        let storyboard = UIStoryboard(name: "PornstarCollectionViewController", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PornstarCollectionViewController") as! PornstarCollectionViewController
        return viewController
    }()
    
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
        
//        self.swipeMenuView.reloadData()
//        self.swipeMenuView.jump(to: self.selectedCategory!, animated: true)
//        self.title = "Categories"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setNavigtionUI() {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "202020")
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconmonstr-menu-1-64").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onLeftTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconmonstr-magnifier-4-64").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onRightTouched))
    }
    
    
    func setupSideMenu() {
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

        SideMenuManager.default.rightMenuNavigationController?.menuWidth = self.view.frame.size.width
        
        
        leftMenuViewController.statusBarEndAlpha = 0
        rightMenuViewController.settings = leftMenuViewController.settings
    }
    
    
    // MARK: - Event
    @objc func onLeftTouched(sender: UIButton) {
        self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc func onRightTouched(sender: UIButton) {
        self.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)        
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
