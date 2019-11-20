//
//  CardController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 20/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class CardController: UIViewController {
    
//    MARK: - Properties
    var creditoBtn: UIButton!
    var debitoBtn: UIButton!
    
    var novaDescricaoLbl: UILabel!
    var descricaoTxt: UITextField!
    
    var novoCartaoLbl: UILabel!
    var numCartaoTxt: UITextField!
    
    var saveBtn: UIButton!
    var closeBtn: UIButton!
    
    
//    MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        
    }
    

//    MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Cartão"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1),
            NSAttributedString.Key.font:UIFont(name:"HelveticaNeue-Bold", size: 26)!,
            NSAttributedString.Key.strokeWidth : -2.0
        ]
    }
    
    
    
    
}
