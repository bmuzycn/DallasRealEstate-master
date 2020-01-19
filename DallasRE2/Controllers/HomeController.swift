//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.

import UIKit
import MessageUI

class HomeController: UITabBarController {
//    var homeControllerDelegate: HomeControllerDelegate?

    // MARK: - Properties
    
    var menuController: MenuController!
//    var centerController: UIViewController!
    var isExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
// MARK: -setup views
    func setup() {
        //set up VCs here
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: 180)
        let listVC = ListVC(collectionViewLayout: layout)
        listVC.homeControllerDelegate = self
        let navController = UINavigationController(rootViewController: listVC)
        navController.navigationBar.titleTextAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!, .foregroundColor: UIColor(red: 255, green: 255, blue: 255)]
        navController.tabBarItem.title = "Home".localized
        navController.tabBarItem.image = UIImage(named: "tab_lunch")
        let webVC = InternetsVC()
        let navWeb = UINavigationController(rootViewController: webVC)
        navWeb.tabBarItem.title = "Website".localized
        navWeb.tabBarItem.image = UIImage(named: "tab_internets")
        
        viewControllers = [navController, navWeb]

    }
}

extension HomeController {
    
    // MARK: - Init

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    // MARK: - Handlers

    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 1)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.menuController.view.frame.origin.x = 0
            }, completion: nil)
            
        } else {
            // hide menu
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.menuController.view.frame.origin.x = 0 - self.view.frame.width
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Profile:
            print("Show profile")
        case .Inbox:
            sendEmail()
        case .Notifications:
            print("Show Notifications")
        case .Settings:
            let controller = SettingsController()
            controller.username = "Batman"
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

}


extension HomeController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
// MARK: -adjust tabbar height

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if UIDevice.current.name.contains("iPhone X") || UIDevice.current.name.contains("iPhone 11") || UIDevice.current.name.contains("iPad"){
            sizeThatFits.height = 90
            return sizeThatFits

        } else {
            sizeThatFits.height = 50 // adjust your size here
            return sizeThatFits
        }

    }
}

extension HomeController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["cindy168988@gmail.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

    }
}
