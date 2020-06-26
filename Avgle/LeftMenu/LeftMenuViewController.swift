//
//  LeftMenuViewController.swift
//  Avgle
//
//  Created by 이기완 on 2018. 8. 12..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SideMenu
import Toast_Swift
import MessageUI


protocol LeftMenuViewControllerDelegate: class {
    func onCollectionTouched(viewController: UIViewController)
    func onCategoryTouched(viewController: UIViewController)
}

class LeftMenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    weak var delegate: LeftMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func onCategoryTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.onCategoryTouched(viewController: self)
        
    }
    
    
    
    @IBAction func onCollectionTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.onCollectionTouched(viewController: self)
    }
    
    
    @IBAction func onEmailTouched(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["kiwan0930@gmail.com"])
                
//                self.present(mail, animated: true, completion: nil)
                UIApplication.topViewController()?.present(mail, animated: true, completion: nil)
            }
        }
            
    }
    
    
    //MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
