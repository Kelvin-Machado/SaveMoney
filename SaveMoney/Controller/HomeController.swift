//
//  HomeController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 19/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//
// Icons made by https://www.flaticon.com/authors/freepik - Freepik from https://www.flaticon.com/

import UIKit

class HomeController: UIViewController {
    
//        MARK: - Properties
    var delegate: HomeControllerDelegate?
        
//        MARK: - Init
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
    }

//        MARK: - Handlers
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Principal"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1),
            NSAttributedString.Key.font:UIFont(name:"HelveticaNeue-Bold", size: 28)!,
            NSAttributedString.Key.strokeWidth : -2.0
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
    }
    
}
