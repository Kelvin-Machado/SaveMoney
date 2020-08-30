//
//  CardController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 20/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class CardController: UIViewController, UITextFieldDelegate {
    
    //    MARK: - Properties
    let realm = try! Realm()
    
    var contas = [Conta]()
    var contasDropDown = [String]()
    var contaSelecionada = ""
    
    var creditoVencimento = Date()
    
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var typeCredito = true
    
    let creditoBtn = UIButton()
    let debitoBtn = UIButton()
    var constraintBtnCredito: NSLayoutConstraint!
    var constraintBtnDebito: NSLayoutConstraint!
    
    var novoCartaoLbl = UILabel()
    
    var descricaoTxt = UITextField()
    var numCartaoTxt = UITextField()
    
    var descricaoDebitoTxt = UITextField()
    var numCartaoDebitoTxt = UITextField()
    
    let saveBtn = UIButton()
    let closeBtn = UIButton()
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var vencimentoTxt: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Vencimento"
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
        dateFormat.dateFormat = "dd/MM/yyyy"
        self.creditoVencimento = sender.date
        self.vencimentoTxt.text = dateFormat.string(from: sender.date)
    }
    
    let dropDownConta = DropDown()
    var dropDownContaBtn = UIButton()
    
    //    MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        configureNavigation()
        configureCredito()
        configureDebito()
        configureDropDownConta()
        configureVencimento()
        configureBottomBtn()
        
    }
    
    
    //    MARK: - Helper Functions
    fileprivate func loadDropDownCartao() {
        dropDownConta.dataSource.removeAll()
        contasDropDown.removeAll()

        for conta in contas{
            if typeCredito {
                if conta.tipo == .cartao {
                    dropDownConta.dataSource.append(contentsOf: ["\(conta.nomeBanco): \(conta.tipo.description)"])
                    self.contasDropDown.append(contentsOf: [conta.numero])
                }
            } else {
                if conta.tipo == .contaCorrente {
                    dropDownConta.dataSource.append(contentsOf: ["\(conta.nomeBanco): \(conta.tipo.description)"])
                    self.contasDropDown.append(contentsOf: [conta.numero])
                }
            }
        }
        
        dropDownContaBtn.layer.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5094178082)
        dropDownContaBtn.setTitle("  Conta", for: .normal)
    }
    
    func configureDropDownConta() {
        contas = Array(realm.objects(Conta.self))

        dropDownConta.direction = .bottom
        dropDownContaBtn.layer.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5094178082)
        dropDownContaBtn.layer.cornerRadius = 5
        dropDownContaBtn.setTitle("  Conta", for: .normal)
        dropDownContaBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        dropDownContaBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        dropDownContaBtn.addTarget(self, action: #selector(selecionaConta), for: .touchUpInside)
        dropDownContaBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        DropDown.startListeningToKeyboard()

        dropDownConta.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")

            self.dropDownConta.hide()
            self.dropDownContaBtn.setTitle("  \(item)", for: .normal)
            self.dropDownContaBtn.backgroundColor = #colorLiteral(red: 0.00238864636, green: 0.4450881481, blue: 0.900737524, alpha: 0.8545323202)
            self.dropDownContaBtn.layer.cornerRadius = 5
            self.dropDownContaBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            self.contaSelecionada = self.contasDropDown[index]
        }
        containerView.addSubview(dropDownContaBtn)
        dropDownConta.anchorView = dropDownContaBtn
        dropDownContaBtn.translatesAutoresizingMaskIntoConstraints = false
        dropDownConta.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropDownContaBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            dropDownContaBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20)
        ])
        constraintBtnCredito = dropDownContaBtn.topAnchor.constraint(equalTo: numCartaoTxt.bottomAnchor, constant: 20)
        constraintBtnCredito.isActive = true
        constraintBtnDebito = dropDownContaBtn.topAnchor.constraint(equalTo: numCartaoDebitoTxt.bottomAnchor, constant: 20)
        constraintBtnDebito.isActive = false
        
        loadDropDownCartao()
    }
    @objc func selecionaConta() {
        dropDownConta.show()
    }
    
    func configureVencimento() {
        
        vencimentoTxt.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(vencimentoTxt)
        
        NSLayoutConstraint.activate([
            vencimentoTxt.topAnchor.constraint(equalTo: dropDownContaBtn.bottomAnchor, constant: 20),
            vencimentoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            vencimentoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            vencimentoTxt.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "003-credit-card").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
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
        typeCredito = true
        creditoBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1) , for: UIControl.State.normal)
        debitoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        
        novoCartaoLbl.removeFromSuperview()
        descricaoDebitoTxt.removeFromSuperview()
        numCartaoDebitoTxt.removeFromSuperview()
        constraintBtnDebito.isActive = false
        configureCreditoInfo()
        constraintBtnCredito.isActive = true
        loadDropDownCartao()
        configureVencimento()
        containerView.addSubview(vencimentoTxt)
    }
    
    func configureCreditoInfo() {
        novoCartaoLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novoCartaoLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novoCartaoLbl.text = "Cadastro do Cartão de Crédito"
        novoCartaoLbl.textColor = .black
        
        descricaoTxt.delegate = self
        descricaoTxt.keyboardType = .default
        descricaoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoTxt.textColor = .black
        descricaoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
                                                                attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoTxt.delegate = self
        numCartaoTxt.keyboardType = .numberPad
        numCartaoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        numCartaoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        numCartaoTxt.textColor = .black
        numCartaoTxt.attributedPlaceholder = NSAttributedString(string: "Número do cartão de crédito",
                                                                attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        numCartaoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoTxt.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        containerView.addSubview(novoCartaoLbl)
        containerView.addSubview(descricaoTxt)
        containerView.addSubview(numCartaoTxt)
        
        novoCartaoLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoTxt.translatesAutoresizingMaskIntoConstraints = false
        numCartaoTxt.translatesAutoresizingMaskIntoConstraints = false
        
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
            numCartaoTxt.widthAnchor.constraint(equalToConstant: 50),
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
        typeCredito = false
        creditoBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1) , for: UIControl.State.normal)
        debitoBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1), for: UIControl.State.normal)
        
        novoCartaoLbl.removeFromSuperview()
        descricaoTxt.removeFromSuperview()
        numCartaoTxt.removeFromSuperview()
        vencimentoTxt.removeFromSuperview()
        constraintBtnCredito.isActive = false
        configureDebitoInfo()
        constraintBtnDebito.isActive = true
        loadDropDownCartao()
    }
    
    func configureDebitoInfo() {
        novoCartaoLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novoCartaoLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novoCartaoLbl.text = "Cadastro do Cartão de Débito"
        novoCartaoLbl.textColor = .black
        
        descricaoDebitoTxt.delegate = self
        descricaoDebitoTxt.keyboardType = .default
        descricaoDebitoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoDebitoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoDebitoTxt.textColor = .black
        descricaoDebitoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoDebitoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        numCartaoDebitoTxt.delegate = self
        numCartaoDebitoTxt.keyboardType = .numberPad
        numCartaoDebitoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        numCartaoDebitoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
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
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonPressed() {
        let novoCartao = Cartao()
        novoCartao.cartaoId = Int64(UUID().hashValue)
        
        if typeCredito {
            novoCartao.nomeCartao = descricaoTxt.text!
            novoCartao.numeroCartao = numCartaoTxt.text!
            novoCartao.tipo = .credito
            novoCartao.dataVencimento = creditoVencimento
        } else {
            novoCartao.nomeCartao = descricaoDebitoTxt.text!
            novoCartao.numeroCartao = numCartaoDebitoTxt.text!
            novoCartao.dataVencimento = nil
            novoCartao.tipo = .debito
        }
        saveCardInfo(cartao: novoCartao)
        
    }
    
    func saveCardInfo(cartao: Cartao) {
        let sucesso = true
        if let conta = realm.objects(Conta.self).filter("numero = '\(contaSelecionada)'").first {
            do {
                try realm.write {
                    realm.add(cartao)
                    conta.cartoes.append(cartao)
                    
                    showAlert(sucesso: sucesso)
                    limparCampos()
                }
            } catch {
                print("Error saving category \(error)")
                showAlert(sucesso: !sucesso)
            }
        } else {
            showAlert(sucesso: !sucesso)
        }
    }
    
    func limparCampos() {
        descricaoTxt.text = ""
        vencimentoTxt.text = ""
        numCartaoTxt.text = ""
        numCartaoDebitoTxt.text = ""
        dropDownContaBtn.isSelected = false
        dropDownContaBtn.layer.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5094178082)
        dropDownContaBtn.setTitle("  Conta", for: .normal)
    }
    
    func showAlert(sucesso: Bool) {
        var msg = ""
        var titulo = ""
        sucesso ? (msg = "Cartão salvo") : (msg = "Falha ao salvar cartão")
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
        //fecha o keyboard quando não está editando
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
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
