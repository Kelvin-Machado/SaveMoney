//
//  CardController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 20/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class CardController: UIViewController, UITextFieldDelegate {
    
//    MARK: - Properties
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    let creditoBtn = UIButton()
    let debitoBtn = UIButton()
    
    var novoCartaoLbl = UILabel()
    
    var descricaoTxt = UITextField()
    var numCartaoTxt = UITextField()
    var vencimento = UITextField()
    
    var descricaoDebitoTxt = UITextField()
    var numCartaoDebitoTxt = UITextField()
    
    let saveBtn = UIButton()
    let closeBtn = UIButton()
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
//    MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboard()
        configureNavigation()
        configureCredito()
        configureDebito()
        configureBottomBtn()
        
    }
    

//    MARK: - Helper Functions
    func configureNavigation() {
        view.backgroundColor = .white
        containerView.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Cartão"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0.4039215686, blue: 0.5254901961, alpha: 1),
            NSAttributedString.Key.font:UIFont(name:"HelveticaNeue-Bold", size: 26)!,
            NSAttributedString.Key.strokeWidth : -2.0
        ]
    }
    
    func makeBackButton() -> UIButton {
        let backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        backButton.tintColor = .blue
        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(.red, for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    
    func configureCredito() {
        creditoBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        creditoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        creditoBtn.backgroundColor = .white
        creditoBtn.setTitle("Crédito", for: .normal)
        
        creditoBtn.addTarget(self, action: #selector(creditoBtnTapped), for: .touchUpInside)
        
        containerView.addSubview(creditoBtn)
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        creditoBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            creditoBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            creditoBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20)
        ])
    }
    
    @objc func creditoBtnTapped() {
        creditoBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1) , for: UIControl.State.normal)
        debitoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        
        descricaoDebitoTxt.removeFromSuperview()
        numCartaoDebitoTxt.removeFromSuperview()
        configureCreditoInfo()
    }
    
    func configureCreditoInfo() {
        novoCartaoLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novoCartaoLbl.backgroundColor = .white
        novoCartaoLbl.text = "Cadastro do Cartão de Crédito"
        novoCartaoLbl.textColor = .black
        
        descricaoTxt.delegate = self
        descricaoTxt.keyboardType = .default
        descricaoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoTxt.backgroundColor = .white
        descricaoTxt.textColor = .black
        descricaoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoTxt.delegate = self
        numCartaoTxt.keyboardType = .numberPad
        numCartaoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        numCartaoTxt.backgroundColor = .white
        numCartaoTxt.textColor = .black
        numCartaoTxt.attributedPlaceholder = NSAttributedString(string: "Número do cartão de crédito",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        numCartaoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoTxt.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        vencimento.delegate = self
        vencimento.keyboardType = .numberPad
        vencimento.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        vencimento.backgroundColor = .white
        vencimento.textColor = .black
        vencimento.textAlignment = .center
        vencimento.attributedPlaceholder = NSAttributedString(string: "Vencimento",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])

        vencimento.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1), width: 1.0)
        
        containerView.addSubview(novoCartaoLbl)
        containerView.addSubview(descricaoTxt)
        containerView.addSubview(numCartaoTxt)
        containerView.addSubview(vencimento)
        
        novoCartaoLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoTxt.translatesAutoresizingMaskIntoConstraints = false
        numCartaoTxt.translatesAutoresizingMaskIntoConstraints = false
        vencimento.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novoCartaoLbl.topAnchor.constraint(equalTo: creditoBtn.bottomAnchor, constant: 20),
            novoCartaoLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            descricaoTxt.topAnchor.constraint(equalTo: novoCartaoLbl.bottomAnchor, constant: 20),
            descricaoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
            
            numCartaoTxt.topAnchor.constraint(equalTo: descricaoTxt.bottomAnchor, constant: 20),
            numCartaoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            numCartaoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            numCartaoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
            
            vencimento.topAnchor.constraint(equalTo: numCartaoTxt.bottomAnchor, constant: 20),
            vencimento.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            numCartaoTxt.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureDebito() {
        debitoBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        debitoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        debitoBtn.backgroundColor = .white
        debitoBtn.setTitle("Débito", for: .normal)
        
        debitoBtn.addTarget(self, action: #selector(debitoBtnTapped), for: .touchUpInside)
        
        containerView.addSubview(debitoBtn)
    
        debitoBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            debitoBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            debitoBtn.leftAnchor.constraint(equalTo: creditoBtn.rightAnchor, constant: 30)
        ])
    }
    
    @objc func debitoBtnTapped() {
        creditoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1) , for: UIControl.State.normal)
        debitoBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1), for: UIControl.State.normal)
        
        descricaoTxt.removeFromSuperview()
        numCartaoTxt.removeFromSuperview()
        vencimento.removeFromSuperview()
        configureDebitoInfo()
    }
    
    func configureDebitoInfo() {
        novoCartaoLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novoCartaoLbl.backgroundColor = .white
        novoCartaoLbl.text = "Cadastro do Cartão de Débito"
        novoCartaoLbl.textColor = .black
        
        descricaoDebitoTxt.delegate = self
        descricaoDebitoTxt.keyboardType = .default
        descricaoDebitoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoDebitoTxt.backgroundColor = .white
        descricaoDebitoTxt.textColor = .black
        descricaoDebitoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoDebitoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoDebitoTxt.delegate = self
        numCartaoDebitoTxt.keyboardType = .numberPad
        numCartaoDebitoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        numCartaoDebitoTxt.backgroundColor = .white
        numCartaoDebitoTxt.textColor = .black
        numCartaoDebitoTxt.attributedPlaceholder = NSAttributedString(string: "Número do cartão de Débito",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        numCartaoDebitoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoDebitoTxt.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        containerView.addSubview(novoCartaoLbl)
        containerView.addSubview(descricaoDebitoTxt)
        containerView.addSubview(numCartaoDebitoTxt)
        
        
        novoCartaoLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoDebitoTxt.translatesAutoresizingMaskIntoConstraints = false
        numCartaoDebitoTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novoCartaoLbl.topAnchor.constraint(equalTo: creditoBtn.bottomAnchor, constant: 20),
            novoCartaoLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            descricaoDebitoTxt.topAnchor.constraint(equalTo: novoCartaoLbl.bottomAnchor, constant: 20),
            descricaoDebitoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoDebitoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoDebitoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
            
            numCartaoDebitoTxt.topAnchor.constraint(equalTo: descricaoDebitoTxt.bottomAnchor, constant: 20),
            numCartaoDebitoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            numCartaoDebitoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            numCartaoDebitoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    
    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    
    func configureBottomBtn() {
        saveBtn.setImage(#imageLiteral(resourceName: "floppy-disk-interface-symbol-for-save-option-button"), for: .normal)
        
        closeBtn.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        closeBtn.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)

        containerView.addSubview(saveBtn)
        containerView.addSubview(closeBtn)
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -30),
            saveBtn.bottomAnchor.constraint(equalTo: keyboardAwareBottomLayoutGuide.topAnchor, constant: -20),
            saveBtn.heightAnchor.constraint(equalToConstant: 40),
            saveBtn.widthAnchor.constraint(equalToConstant: 40),
            
            closeBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 30),
            closeBtn.bottomAnchor.constraint(equalTo: keyboardAwareBottomLayoutGuide.topAnchor, constant: -20),
            closeBtn.heightAnchor.constraint(equalToConstant: 40),
            closeBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
  //MARK: - Keyboard Events
  
  func setupKeyboard() {
      self.view.addLayoutGuide(self.keyboardAwareBottomLayoutGuide)
      
      self.keyboardTopAnchorConstraint = self.view.layoutMarginsGuide.bottomAnchor.constraint(equalTo: keyboardAwareBottomLayoutGuide.topAnchor, constant: 0)
      self.keyboardTopAnchorConstraint.isActive = true
      self.keyboardAwareBottomLayoutGuide.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        updateKeyboardAwareBottomLayoutGuide(with: notification, hiding: false)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
         updateKeyboardAwareBottomLayoutGuide(with: notification, hiding: true)
    }
  
  fileprivate func updateKeyboardAwareBottomLayoutGuide(with notification: NSNotification, hiding: Bool) {
      let userInfo = notification.userInfo

      let animationDuration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
      let keyboardEndFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

      let rawAnimationCurve = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value

      guard let animDuration = animationDuration,
          let keybrdEndFrame = keyboardEndFrame,
          let rawAnimCurve = rawAnimationCurve else {
              return
      }

      let convertedKeyboardEndFrame = view.convert(keybrdEndFrame, from: view.window)

      let rawAnimCurveAdjusted = UInt(rawAnimCurve << 16)
      let animationCurve = UIView.AnimationOptions(rawValue: rawAnimCurveAdjusted)

      self.keyboardTopAnchorConstraint.constant = hiding ? 0 : convertedKeyboardEndFrame.size.height

      self.view.setNeedsLayout()

      UIView.animate(withDuration: animDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
          self.view.layoutIfNeeded()
      }, completion: { success in
          //
      })
  }
    
}
