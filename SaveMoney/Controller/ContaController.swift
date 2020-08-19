//
//  ContaController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class ContaController: UIViewController, UITextFieldDelegate {
    
//    MARK: - Properties

    let realm = try! Realm()
    var conta: Results<Conta>?

    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    let creditoBtn = UIButton()
    let debitoBtn = UIButton()
    var credito: Bool = true
    
    var novaContaLbl = UILabel()
    
    var descricaoTxt = UITextField()
    var numContaTxt = UITextField()
    var saldo = UITextField()
    
    var descricaoDebitoTxt = UITextField()
    var numContaDebitoTxt = UITextField()
    var saldoDebito = UITextField()
    
    let saveBtn = UIButton()
    let closeBtn = UIButton()
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
//    MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        conta = realm.objects(Conta.self)
        setupKeyboard()
        configureNavigation()
        configureCredito()
        configureDebito()
        configureBottomBtn()
        loadSavedConta()
    }

//    MARK: - Helper Functions
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "005-cash-flow").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Conta"
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
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    
    func configureCredito() {
        creditoBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        creditoBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1), for: UIControl.State.normal)
        creditoBtn.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
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
        configureCreditoInfo()
    }
    
    @objc func creditoBtnTapped() {
        creditoBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1) , for: UIControl.State.normal)
        debitoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)

        credito = true

        novaContaLbl.removeFromSuperview()
        descricaoDebitoTxt.removeFromSuperview()
        numContaDebitoTxt.removeFromSuperview()
        saldoDebito.removeFromSuperview()
        configureCreditoInfo()
    }
    
    func configureCreditoInfo() {
        novaContaLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novaContaLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novaContaLbl.text = "Cadastrar nova conta em crédito"
        novaContaLbl.textColor = .black
        
        descricaoTxt.delegate = self
        descricaoTxt.keyboardType = .default
        descricaoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoTxt.textColor = .black
        descricaoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numContaTxt.delegate = self
        numContaTxt.keyboardType = .numberPad
        numContaTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        numContaTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        numContaTxt.textColor = .black
        numContaTxt.attributedPlaceholder = NSAttributedString(string: "Número da conta",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        numContaTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        saldo.delegate = self
        saldo.keyboardType = .numberPad
        saldo.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        saldo.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        saldo.textColor = .black
        saldo.textAlignment = .center
        saldo.attributedPlaceholder = NSAttributedString(string: "Saldo",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        saldo.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        saldo.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1), width: 1.0)
        
        containerView.addSubview(novaContaLbl)
        containerView.addSubview(descricaoTxt)
        containerView.addSubview(numContaTxt)
        containerView.addSubview(saldo)
        
        novaContaLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoTxt.translatesAutoresizingMaskIntoConstraints = false
        numContaTxt.translatesAutoresizingMaskIntoConstraints = false
        saldo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novaContaLbl.topAnchor.constraint(equalTo: creditoBtn.bottomAnchor, constant: 20),
            novaContaLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            descricaoTxt.topAnchor.constraint(equalTo: novaContaLbl.bottomAnchor, constant: 20),
            descricaoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
            
            numContaTxt.topAnchor.constraint(equalTo: descricaoTxt.bottomAnchor, constant: 20),
            numContaTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            numContaTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            numContaTxt.widthAnchor.constraint(equalToConstant: 50),
            
            saldo.topAnchor.constraint(equalTo: numContaTxt.bottomAnchor, constant: 20),
            saldo.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30)
        ])
    }
    
    func configureDebito() {
        debitoBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        debitoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        debitoBtn.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
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

        credito = false

        novaContaLbl.removeFromSuperview()
        descricaoTxt.removeFromSuperview()
        numContaTxt.removeFromSuperview()
        saldo.removeFromSuperview()
        configureDebitoInfo()
    }
    
    func configureDebitoInfo() {
        novaContaLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novaContaLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novaContaLbl.text = "Cadastrar nova conta em débito"
        novaContaLbl.textColor = .black
        
        descricaoDebitoTxt.delegate = self
        descricaoDebitoTxt.keyboardType = .default
        descricaoDebitoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoDebitoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoDebitoTxt.textColor = .black
        descricaoDebitoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoDebitoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numContaDebitoTxt.delegate = self
        numContaDebitoTxt.keyboardType = .numberPad
        numContaDebitoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        numContaDebitoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        numContaDebitoTxt.textColor = .black
        numContaDebitoTxt.attributedPlaceholder = NSAttributedString(string: "Número da conta",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        numContaDebitoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        saldoDebito.delegate = self
        saldoDebito.keyboardType = .numberPad
        saldoDebito.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        saldoDebito.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        saldoDebito.textColor = .black
        saldoDebito.textAlignment = .center
        saldoDebito.attributedPlaceholder = NSAttributedString(string: "Saldo",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        saldoDebito.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        saldoDebito.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1), width: 1.0)
        
        containerView.addSubview(novaContaLbl)
        containerView.addSubview(descricaoDebitoTxt)
        containerView.addSubview(numContaDebitoTxt)
        containerView.addSubview(saldoDebito)
        
        
        novaContaLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoDebitoTxt.translatesAutoresizingMaskIntoConstraints = false
        numContaDebitoTxt.translatesAutoresizingMaskIntoConstraints = false
        saldoDebito.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novaContaLbl.topAnchor.constraint(equalTo: creditoBtn.bottomAnchor, constant: 20),
            novaContaLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            descricaoDebitoTxt.topAnchor.constraint(equalTo: novaContaLbl.bottomAnchor, constant: 20),
            descricaoDebitoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoDebitoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoDebitoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
            
            numContaDebitoTxt.topAnchor.constraint(equalTo: descricaoDebitoTxt.bottomAnchor, constant: 20),
            numContaDebitoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            numContaDebitoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            numContaDebitoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
            
            saldoDebito.topAnchor.constraint(equalTo: numContaDebitoTxt.bottomAnchor, constant: 20),
            saldoDebito.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30)
        ])
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
        let novaConta = Conta()
        if credito {
            novaConta.contaId = 0
            novaConta.nomeBanco = descricaoTxt.text!
            novaConta.numero = numContaTxt.text!
            novaConta.saldo = saldo.text!.toDoubleWithAutoLocale()!.roundToDecimal(2)
            novaConta.tipoEnum = .cartao
        } else {
            novaConta.contaId = 1
            novaConta.nomeBanco = descricaoDebitoTxt.text!
            novaConta.numero = numContaDebitoTxt.text!
            novaConta.saldo = saldoDebito.text!.toDoubleWithAutoLocale()!.roundToDecimal(2)
            novaConta.tipoEnum = .contaCorrente
        }
        save(conta: novaConta)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = saldo.text?.currencyInputFormatting() {
           saldo.text = amountString
        }
        if let amountString = saldoDebito.text?.currencyInputFormatting() {
            saldoDebito.text = amountString
        }
    }

    // MARK: - Data Manipulation Methods
    func save(conta: Conta) {
        let sucesso = true
        do {
            try realm.write {
                if realm.isEmpty {
                    realm.add(conta)
                 } else {
                    realm.add(conta, update: .modified)
                }
                showAlert(sucesso: sucesso)
            }
        } catch {
            print("Error saving category \(error)")
            showAlert(sucesso: !sucesso)
        }
    }
    
    func loadSavedConta() {
            do {
                try realm.write {
                    if !realm.isEmpty {
                        conta = realm.objects(Conta.self)
                        descricaoTxt.text = conta?[0].nomeBanco
                        numContaTxt.text = conta?[0].numero
                        saldo.text = conta![0].saldo.description
                        descricaoDebitoTxt.text = conta?[1].nomeBanco
                        numContaDebitoTxt.text = conta?[1].numero
                        saldoDebito.text = conta![1].saldo.description
                    }
                }
            } catch {
                print("Erro ao carregar cartão de crédito \(error)")
            }
        }

    
    func showAlert(sucesso: Bool) {
        var msg = ""
        var titulo = ""
        sucesso ? (msg = "Os dados da conta foram salvos") : (msg = "Dados não foram salvos")
        sucesso ? (titulo = "Sucesso!!!") : (titulo = "Erro")
        let alert = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style {
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")

              @unknown default:
                fatalError()
            }}))
        self.present(alert, animated: true, completion: nil)
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
        
      })
  }
    
}
