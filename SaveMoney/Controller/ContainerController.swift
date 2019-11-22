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
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
        
//        MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
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
            menuController.delegate = self
            
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?){
        
        if shouldExpand {
            //show menu
            let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame = CGRect(x: self.centerController.view.frame.width - 80, y: 0, width: self.centerController.view.frame.width, height: self.centerController.view.frame.height + height)
                }, completion: nil)
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
        }else{
            //hide menu
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) {(_) in
                guard let menuOption = menuOption else {return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
        }
        
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .cartao:
            let controller = CardController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen //push the controller in fullscreen
            present(navController, animated: true, completion: nil) //push CardController
        case .emitente:
            let controller = EmitenteController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .conta:
            let controller = ContaController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .categoria:
            let controller = CategoriaController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .despesa:
            let controller = DespesaController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .receita:
            let controller = ReceitaController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .orcamento:
            let controller = OrcamentoController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .grafico:
            let controller = GraficoController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        case .movimentacao:
            let controller = MovimentacaoController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
}

//      MARK: - Extension

extension ContainerController: HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
        
    }
}
