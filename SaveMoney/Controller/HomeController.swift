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
        delegate?.handleMenuToggle()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3960784314, green: 0.6, blue: 1, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Principal"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0.3960784314, green: 0.4461847175, blue: 0.9267444349, alpha: 1),
            NSAttributedString.Key.font:UIFont(name:"HelveticaNeue-Bold", size: 28)!,
            NSAttributedString.Key.strokeWidth : -4.0
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
    }
    
}
