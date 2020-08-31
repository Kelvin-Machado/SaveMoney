//
//  OrcamentoController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class OrcamentoController: UIViewController, UITextFieldDelegate {
    
//    MARK: - Properties
    let realm = try! Realm()
    
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    var mesOrcamento = Date()
    
    
    lazy var monthTxt: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Escolha o mês e ano"
        txt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        txt.layer.borderWidth = 1
        txt.layer.cornerRadius = 5
        txt.borderStyle = .roundedRect
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.7013324058)
        datePicker.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        txt.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(self.selecionaData), for: .valueChanged)
        return txt
    }()
    
    @objc func selecionaData(sender: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        dateFormat.dateStyle = .long
        self.mesOrcamento = sender.date
        self.monthTxt.text = dateFormat.string(from: sender.date)
    }
    
    let metaLbl = UILabel()
    let rsLbl = UILabel()
    let valueTxt = UITextField()
    
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
        configureMonth()
        configureGoal()
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
    
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "001-cost").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Orçamento"
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
    
    
    func configureMonth() {
        monthTxt.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(monthTxt)
        monthTxt.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        monthTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
    }
    
//    func getDate() -> String {
//
//        let date = Date()
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: date)
//        return ("\(Months.init(rawValue: month-1)!)")
//    }
    
    func  configureGoal() {
        metaLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        metaLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        metaLbl.text = "Meta"
        metaLbl.textColor = .black
        
        rsLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        rsLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        rsLbl.text = "R$"
        rsLbl.textColor = .black
        
        valueTxt.delegate = self
        valueTxt.keyboardType = .numberPad
        valueTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        valueTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        valueTxt.textColor = .black
        valueTxt.textAlignment = .center
        valueTxt.attributedPlaceholder = NSAttributedString(string: "Valor",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        valueTxt.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        valueTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1), width: 1.0)
        
        containerView.addSubview(metaLbl)
        containerView.addSubview(valueTxt)
        containerView.addSubview(rsLbl)
        
        rsLbl.translatesAutoresizingMaskIntoConstraints = false
        metaLbl.translatesAutoresizingMaskIntoConstraints = false
        valueTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            metaLbl.topAnchor.constraint(equalTo: monthTxt.bottomAnchor, constant: 20),
            metaLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            rsLbl.topAnchor.constraint(equalTo: metaLbl.bottomAnchor, constant: 20),
            rsLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            valueTxt.topAnchor.constraint(equalTo: metaLbl.bottomAnchor, constant: 20),
            valueTxt.leftAnchor.constraint(equalTo: rsLbl.leftAnchor, constant: 30)
        ])
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

       if let amountString = textField.text?.currencyInputFormatting() {
           textField.text = amountString
       }
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
        let novoOrcamento = Orcamento()
        novoOrcamento.meta = valueTxt.text!.toDoubleWithAutoLocale()!.roundToDecimal(2)
        novoOrcamento.data = mesOrcamento
        novoOrcamento.ativo = true
        save(orcamento: novoOrcamento)
    }
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Manipulation Methods

    func save(orcamento: Orcamento) {
        let sucesso = true
        let despesas = realm.objects(Despesa.self)
        for despesa in despesas {
            
            if despesa.dataVencimento >= mesOrcamento.startOfMonth
            && despesa.dataVencimento <= mesOrcamento.endOfMonth {
                do {
                    try realm.write {
                        realm.add(orcamento)
                        despesa.orcamentos.append(orcamento)
                        
                        showAlert(sucesso: sucesso)
                    }
                } catch {
                    print("Error saving category \(error)")
                    showAlert(sucesso: !sucesso)
                }
            } else {
                showAlert(sucesso: !sucesso)
            }
        }
        
    }
    
    func showAlert(sucesso: Bool) {
        var msg = ""
        var titulo = ""
        sucesso ? (msg = "Orçamento salvo") : (msg = "Falha ao salvar orçamento")
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

