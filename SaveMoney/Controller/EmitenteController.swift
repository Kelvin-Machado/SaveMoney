//
//  EmitenteController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class EmitenteController: UIViewController, UITextFieldDelegate {
    
//    MARK: - Properties
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    var checkmarkCPFSelected = false
    var checkmarkCNPJSelected = false
    
    let novoEmitenteLbl = UILabel()
    let nomeEmitenteTxt = UITextField()
    let cpfTxt = UITextField()
    let cnpjTxt = UITextField()
    let emailTxt = UITextField()
    let telefoneTxt = UITextField()
    
    let cpfBtn = UIButton()
    let cnpjBtn = UIButton()
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
        configureNovoEmitente()
        configureCheckbox()
        configureCPF()
        configureEmail()
        ConfigureTelefone()
        configureBottomBtn()
        
    }

    //    MARK: - Helper Functions
    
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

    func configureNovoEmitente() {
        
        novoEmitenteLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        novoEmitenteLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novoEmitenteLbl.text = "Novo Emitente"
        novoEmitenteLbl.textColor = .black
        
        nomeEmitenteTxt.delegate = self
        nomeEmitenteTxt.keyboardType = .default
        nomeEmitenteTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        nomeEmitenteTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        nomeEmitenteTxt.textColor = .black
        nomeEmitenteTxt.attributedPlaceholder = NSAttributedString(string: "Nome/Razão Social",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        nomeEmitenteTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(novoEmitenteLbl)
        containerView.addSubview(nomeEmitenteTxt)
        
        novoEmitenteLbl.translatesAutoresizingMaskIntoConstraints = false
        nomeEmitenteTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novoEmitenteLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            novoEmitenteLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            nomeEmitenteTxt.topAnchor.constraint(equalTo: novoEmitenteLbl.bottomAnchor, constant: 20),
            nomeEmitenteTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            nomeEmitenteTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            nomeEmitenteTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    
    func configureCheckbox() {
        
        cpfBtn.frame = CGRect(x: 64, y: 64, width: 50, height: 50)
        cpfBtn.titleLabel?.text = "CPF"
        cpfBtn.setTitle("CPF", for: .normal)
        cpfBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        cpfBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4892972708, blue: 0.8952963948, alpha: 1), for: .normal)
        cpfBtn.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal);
        cpfBtn.addTarget(self, action: #selector(checkmarkCPF), for: .touchUpInside)
        
        cnpjBtn.frame = CGRect(x: 64, y: 64, width: 50, height: 50)
        cnpjBtn.setTitle("CNPJ", for: .normal)
        cnpjBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        cnpjBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        cnpjBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal);
        cnpjBtn.addTarget(self, action: #selector(checkmarkCNPJ), for: .touchUpInside)
        
        containerView.addSubview(cpfBtn)
        containerView.addSubview(cnpjBtn)
        
        cpfBtn.translatesAutoresizingMaskIntoConstraints = false
        cnpjBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        cpfBtn.topAnchor.constraint(equalTo: nomeEmitenteTxt.bottomAnchor, constant: 20),
        cpfBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
        cnpjBtn.topAnchor.constraint(equalTo: nomeEmitenteTxt.bottomAnchor, constant: 20),
        cnpjBtn.leftAnchor.constraint(equalTo: cpfBtn.titleLabel?.leftAnchor ?? cpfBtn.leftAnchor, constant: 50),
        
        ])
    }
    
    @objc func checkmarkCPF() {
        cnpjBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal);
        cpfBtn.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal);
        cpfBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4892972708, blue: 0.8952963948, alpha: 1), for: .normal)
        cnpjBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        containerView.willRemoveSubview(cnpjTxt)
        configureCPF()
        
    }
    @objc func checkmarkCNPJ() {
        cpfBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal);
        cnpjBtn.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal);
        cpfBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        cnpjBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4892972708, blue: 0.8952963948, alpha: 1), for: .normal)
        containerView.willRemoveSubview(cpfTxt)
        configureCNPJ()
    }
    
    func configureCPF() {
        
        cpfTxt.delegate = self
        cpfTxt.keyboardType = .numberPad
        cpfTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        cpfTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        cpfTxt.textColor = .black
        cpfTxt.attributedPlaceholder = NSAttributedString(string: "CPF",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        cpfTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(cpfTxt)
        
        cpfTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cpfTxt.topAnchor.constraint(equalTo: cpfBtn.bottomAnchor, constant: 20),
            cpfTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            cpfTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            cpfTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    
    func configureCNPJ() {
        
        cnpjTxt.delegate = self
        cnpjTxt.keyboardType = .numberPad
        cnpjTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        cnpjTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        cnpjTxt.textColor = .black
        cnpjTxt.attributedPlaceholder = NSAttributedString(string: "CNPJ",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        cnpjTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(cnpjTxt)
        
        cnpjTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cnpjTxt.topAnchor.constraint(equalTo: cpfBtn.bottomAnchor, constant: 20),
            cnpjTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            cnpjTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            cnpjTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    
    func configureEmail() {
        emailTxt.delegate = self
        emailTxt.keyboardType = .emailAddress
        emailTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        emailTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        emailTxt.textColor = .black
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        emailTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(emailTxt)
        
        emailTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTxt.topAnchor.constraint(equalTo: cpfTxt.bottomAnchor, constant: 20),
            emailTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            emailTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            emailTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    
    func ConfigureTelefone() {
        telefoneTxt.delegate = self
        telefoneTxt.keyboardType = .numberPad
        telefoneTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        telefoneTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        telefoneTxt.textColor = .black
        telefoneTxt.attributedPlaceholder = NSAttributedString(string: "Telefone",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        telefoneTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(telefoneTxt)
        
        telefoneTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            telefoneTxt.topAnchor.constraint(equalTo: emailTxt.bottomAnchor, constant: 20),
            telefoneTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            telefoneTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            telefoneTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "004-bill").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4509803922, blue: 0.9019607843, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Emitente"
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
            saveBtn.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
            
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
        @objc func saveButtonPressed() {
            
            if cpfTxt.text!.isValidCPF {
                print("CPF Válido")
            }else{
                print("CPF Inválido")
            }
            
            
            if cnpjTxt.text!.isValidCNPJ {
                print("CNPJ Válido")
            }else{
                print("CNPJ Inválido")
            }
        
            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
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

