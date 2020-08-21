//
//  DespesaController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class DespesaController: UIViewController, UITextFieldDelegate {
    
//    MARK: - Properties
    let realm = try! Realm()
    var despesa: Results<Despesa>?

    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    let saveBtn = UIButton()
    let closeBtn = UIButton()
    
    let novaDespesaLbl = UILabel()
    let descricaoDespesaTxt = UITextField()
    let rsLbl = UILabel()
    let valor = UITextField()
    let pagBtn = UIButton()
    
    var check = false

    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
//    MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        despesa = realm.objects(Despesa.self)
        setupKeyboard()
        configureNavigation()
        configureContainer()
        configureNovaDespesa()
        configureValor()
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
    
    func configureNovaDespesa() {
        
        novaDespesaLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        novaDespesaLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novaDespesaLbl.text = "Nova Despesa"
        novaDespesaLbl.textColor = .black
        
        descricaoDespesaTxt.delegate = self
        descricaoDespesaTxt.keyboardType = .default
        descricaoDespesaTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoDespesaTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoDespesaTxt.textColor = .black
        descricaoDespesaTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoDespesaTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(novaDespesaLbl)
        containerView.addSubview(descricaoDespesaTxt)
        
        novaDespesaLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoDespesaTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novaDespesaLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            novaDespesaLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            descricaoDespesaTxt.topAnchor.constraint(equalTo: novaDespesaLbl.bottomAnchor, constant: 20),
            descricaoDespesaTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoDespesaTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoDespesaTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
        ])
    }
    
    func configureValor() {
        rsLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        rsLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        rsLbl.text = "R$"
        rsLbl.textColor = .black
        
        valor.delegate = self
        valor.keyboardType = .numberPad
        valor.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        valor.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        valor.textColor = .black
        valor.textAlignment = .center
        valor.attributedPlaceholder = NSAttributedString(string: "valor",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        valor.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        valor.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1), width: 1.0)
        
        pagBtn.frame = CGRect(x: 64, y: 64, width: 50, height: 50)
        pagBtn.setTitle("Pago", for: .normal)
        pagBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        pagBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        pagBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal)
        pagBtn.addTarget(self, action: #selector(checkmarkPagBtn), for: .touchUpInside)
        
        containerView.addSubview(rsLbl)
        containerView.addSubview(valor)
        containerView.addSubview(pagBtn)
               
        rsLbl.translatesAutoresizingMaskIntoConstraints = false
        valor.translatesAutoresizingMaskIntoConstraints = false
        pagBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rsLbl.topAnchor.constraint(equalTo: descricaoDespesaTxt.bottomAnchor, constant: 20),
            rsLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            valor.topAnchor.constraint(equalTo: descricaoDespesaTxt.bottomAnchor, constant: 20),
            valor.leftAnchor.constraint(equalTo: rsLbl.rightAnchor, constant: 1),
            pagBtn.topAnchor.constraint(equalTo: descricaoDespesaTxt.bottomAnchor, constant: 20),
            pagBtn.leftAnchor.constraint(equalTo: containerView.rightAnchor, constant: -80)
        ])
    }

//    MARK: - Helper Functions
    
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "010-deposit").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Despesa"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0.4039215686, blue: 0.5254901961, alpha: 1),
            NSAttributedString.Key.font:UIFont(name:"HelveticaNeue-Bold", size: 26)!,
            NSAttributedString.Key.strokeWidth : -2.0
        ]
    }
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = valor.text?.currencyInputFormatting() {
           valor.text = amountString
        }
    }
    
    @objc func checkmarkPagBtn() {
        if !check {
            pagBtn.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
            pagBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4892972708, blue: 0.8952963948, alpha: 1), for: .normal)
            check = true
        } else {
            pagBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal)
            pagBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            check = false
        }
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
            let novaDespesa = Despesa()
            novaDespesa.descricao = descricaoDespesaTxt.text!
            novaDespesa.valorDespesa = valor.text!.toDoubleWithAutoLocale()!.roundToDecimal(2)
            novaDespesa.aPagar = check
            save(despesa: novaDespesa)
        }
        
        @objc func backButtonPressed() {
            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }
    
    // MARK: - Data Manipulation Methods
    func save(despesa: Despesa) {
        let sucesso = true
        do {
            try realm.write {
                    realm.add(despesa)
                showAlert(sucesso: sucesso)
            }
        } catch {
            print("Error saving category \(error)")
            showAlert(sucesso: !sucesso)
        }
    }
    
    func showAlert(sucesso: Bool) {
        var msg = ""
        var titulo = ""
        sucesso ? (msg = "Despesa salva") : (msg = "Falha ao salvar despesa")
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
              //
          })
      }
        
    }


