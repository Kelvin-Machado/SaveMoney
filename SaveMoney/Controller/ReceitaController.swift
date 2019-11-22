//
//  ReceitaController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class ReceitaController: UIViewController, UITextFieldDelegate {
    
//    MARK: - Properties
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
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
        configureContainer()
        configureBottomBtn()
        
    }
    
    func configureContainer() {
        
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

//    MARK: - Helper Functions
    
    func configureNavigation() {
        view.backgroundColor = .white
        containerView.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "009-business-and-finance").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Receita"
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
    
        
    //    MARK: - Configure bottom buttons
        
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


