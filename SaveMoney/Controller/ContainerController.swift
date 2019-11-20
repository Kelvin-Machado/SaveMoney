//
//  ContainerController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 19/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
//        MARK: - Properties
    
    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExpanded = false
        
//        MARK: - Init
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeController()
        
        view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }

//        MARK: - Handlers
    
    func configureHomeController() {
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            //add menu controller
            menuController = MenuController()
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func showMenuController(shouldExpand: Bool){
        
        if shouldExpand {
            //show menu
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        }else{
            //hide menu
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle() {
        
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded)
    }
}
