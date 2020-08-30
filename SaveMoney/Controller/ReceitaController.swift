//
//  ReceitaController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class ReceitaController: UIViewController, UITextFieldDelegate {
    
    //    MARK: - Properties
    let realm = try! Realm()
    
    var categorias = [Categoria]()
    var contas = [Conta]()
    var emitentes = [Emitente]()
    var categoriaSelecionada = ""
    var contaSelecionada = 0
    var emitenteSelecionado = ""
    
    var dataRecebimento = Date()
    
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    let saveBtn = UIButton()
    let closeBtn = UIButton()
    
    let novaReceitaLbl = UILabel()
    let descricaoReceitaTxt = UITextField()
    let rsLbl = UILabel()
    let valor = UITextField()
    let pagBtn = UIButton()
    
    lazy var vencimentoTxt: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Data do recebimento"
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
        self.dataRecebimento = sender.date
        self.vencimentoTxt.text = dateFormat.string(from: sender.date)
    }
    
    var check = true
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    let dropDown = DropDown()
    var dropDownBtn = UIButton()
    let dropDownConta = DropDown()
    var dropDownContaBtn = UIButton()
    let dropDownEmitente = DropDown()
    var dropDownEmitenteBtn = UIButton()
    
    //    MARK: - Init
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        configureNavigation()
        configureContainer()
        configureNovaReceita()
        configureValor()
        configureDropDown()
        configureDropDownCategoria()
        configureDropDownConta()
        configureDropDownEmitente()
        configureVencimento()
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
    
    func configureNovaReceita() {
        
        novaReceitaLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        novaReceitaLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novaReceitaLbl.text = "Nova Receita"
        novaReceitaLbl.textColor = .black
        
        descricaoReceitaTxt.delegate = self
        descricaoReceitaTxt.keyboardType = .default
        descricaoReceitaTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoReceitaTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoReceitaTxt.textColor = .black
        descricaoReceitaTxt.attributedPlaceholder = NSAttributedString(string: " Descrição",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoReceitaTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(novaReceitaLbl)
        containerView.addSubview(descricaoReceitaTxt)
        
        novaReceitaLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoReceitaTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novaReceitaLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            novaReceitaLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            
            descricaoReceitaTxt.topAnchor.constraint(equalTo: novaReceitaLbl.bottomAnchor, constant: 20),
            descricaoReceitaTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoReceitaTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoReceitaTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60)
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
        valor.attributedPlaceholder = NSAttributedString(string: " valor",
                                                         attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        valor.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        valor.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1), width: 1.0)
        
        pagBtn.frame = CGRect(x: 64, y: 64, width: 80, height: 50)
        pagBtn.setTitle("Recebido", for: .normal)
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
            rsLbl.topAnchor.constraint(equalTo: descricaoReceitaTxt.bottomAnchor, constant: 20),
            rsLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            valor.topAnchor.constraint(equalTo: descricaoReceitaTxt.bottomAnchor, constant: 20),
            valor.leftAnchor.constraint(equalTo: rsLbl.rightAnchor, constant: 1),
            pagBtn.topAnchor.constraint(equalTo: descricaoReceitaTxt.bottomAnchor, constant: 20),
            pagBtn.leftAnchor.constraint(equalTo: containerView.rightAnchor, constant: -160)
        ])
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = valor.text?.currencyInputFormatting() {
            valor.text = amountString
        }
    }
    
    func configureVencimento() {
        
        vencimentoTxt.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(vencimentoTxt)
        
        NSLayoutConstraint.activate([
            vencimentoTxt.topAnchor.constraint(equalTo: dropDownEmitenteBtn.bottomAnchor, constant: 20),
            vencimentoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            vencimentoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            vencimentoTxt.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //    MARK: - Helper Functions
    
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
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
    @objc func checkmarkPagBtn() {
        if check {
            pagBtn.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
            pagBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4892972708, blue: 0.8952963948, alpha: 1), for: .normal)
            check = false //já foi recebido
        } else {
            pagBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal)
            pagBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            check = true // ainda não foi recebido
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
    
    func limparCampos() {
        descricaoReceitaTxt.text! = ""
        valor.text! = ""
        pagBtn.setImage(#imageLiteral(resourceName: "checkmark_empty"), for: .normal)
        pagBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        check = true
        vencimentoTxt.text = ""
        dropDownBtn.isSelected = false
        dropDownBtn.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.6372538527)
        dropDownBtn.setTitle("  Categoria", for: .normal)
        dropDownContaBtn.isSelected = false
        dropDownContaBtn.layer.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.6460027825)
        dropDownContaBtn.setTitle("  Conta", for: .normal)
        dropDownEmitenteBtn.isSelected = false
        dropDownEmitenteBtn.layer.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 0.6481699486)
        dropDownEmitenteBtn.setTitle("  Emitente", for: .normal)
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
        let novaReceita = Receita()
        novaReceita.descricao = descricaoReceitaTxt.text!
        novaReceita.valorReceita = valor.text!.toDoubleWithAutoLocale()!.roundToDecimal(2)
        novaReceita.aReceber = check
        novaReceita.dataLancamento = dataRecebimento
        save(receita: novaReceita)
    }
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Manipulation Methods
    func save(receita: Receita) {
        let sucesso = true
        if let conta = realm.objects(Conta.self).filter("contaId = \(contaSelecionada)").first {
            if let categoria = realm.objects(Categoria.self).filter("descricao = '\(categoriaSelecionada)'").first {
                if let emitente = realm.objects(Emitente.self).filter("razaoSocial = '\(emitenteSelecionado)'").first {
                    do {
                        try realm.write {
                            realm.add(receita)
                            conta.receitas.append(receita)
                            categoria.receitas.append(receita)
                            emitente.receitas.append(receita)
                            
                            showAlert(sucesso: sucesso)
                            limparCampos()
                        }
                    } catch {
                        print("Error saving category \(error)")
                        showAlert(sucesso: !sucesso)
                    }
                }
            }
        } else {
            showAlert(sucesso: !sucesso)
        }
        
    }
    
    func showAlert(sucesso: Bool) {
        var msg = ""
        var titulo = ""
        sucesso ? (msg = "Receita salva") : (msg = "Falha ao salvar receita")
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



//MARK: - DropDown Menu

extension ReceitaController {
    
    func configureDropDown() {
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.white
        DropDown.appearance().textFont = UIFont(name:"HelveticaNeue-Bold", size: 15)!
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = #colorLiteral(red: 0.00238864636, green: 0.4450881481, blue: 0.900737524, alpha: 1)
    }
    
    func configureDropDownCategoria() {
        categorias = Array(realm.objects(Categoria.self))
        
        dropDown.direction = .bottom
        dropDownBtn.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.6372538527)
        dropDownBtn.layer.cornerRadius = 5
        dropDownBtn.setTitle("  Categoria", for: .normal)
        dropDownBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        dropDownBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        dropDownBtn.addTarget(self, action: #selector(selecionaCategoria), for: .touchUpInside)
        dropDownBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        DropDown.startListeningToKeyboard()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            
            
            self.dropDown.hide()
            self.dropDownBtn.setTitle("  \(item)", for: .normal)
            self.dropDownBtn.backgroundColor = #colorLiteral(red: 0.00238864636, green: 0.4450881481, blue: 0.900737524, alpha: 0.7036868579)
            self.dropDownBtn.layer.cornerRadius = 5
            self.dropDownBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.categoriaSelecionada = item
            
            
        }
        
        for categoria in categorias{
            if categoria.tipo == .receita {
                dropDown.dataSource.append(contentsOf: [categoria.descricao])
            }
        }
        
        containerView.addSubview(dropDownBtn)
        dropDown.anchorView = dropDownBtn
        dropDownBtn.translatesAutoresizingMaskIntoConstraints = false
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropDownBtn.topAnchor.constraint(equalTo: valor.bottomAnchor, constant: 20),
            dropDownBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            dropDownBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20)
        ])
        
    }
    @objc func selecionaCategoria() {
        dropDown.show()
    }
    
    func configureDropDownConta() {
        contas = Array(realm.objects(Conta.self))
        
        dropDownConta.direction = .bottom
        dropDownContaBtn.layer.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.6460027825)
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
            
            self.contaSelecionada = index
        }
        
        for conta in contas{
            dropDownConta.dataSource.append(contentsOf: ["\(conta.nomeBanco): \(conta.tipo.description)"])
        }
        
        containerView.addSubview(dropDownContaBtn)
        dropDownConta.anchorView = dropDownContaBtn
        dropDownContaBtn.translatesAutoresizingMaskIntoConstraints = false
        dropDownConta.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropDownContaBtn.topAnchor.constraint(equalTo: dropDownBtn.bottomAnchor, constant: 20),
            dropDownContaBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            dropDownContaBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20)
        ])
        
    }
    @objc func selecionaConta() {
        dropDownConta.show()
    }
    
    func configureDropDownEmitente() {
        emitentes = Array(realm.objects(Emitente.self))
        
        dropDownEmitente.direction = .bottom
        dropDownEmitenteBtn.layer.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 0.6481699486)
        dropDownEmitenteBtn.layer.cornerRadius = 5
        dropDownEmitenteBtn.setTitle("  Emitente", for: .normal)
        dropDownEmitenteBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        dropDownEmitenteBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        dropDownEmitenteBtn.addTarget(self, action: #selector(selecionaEmitente), for: .touchUpInside)
        dropDownEmitenteBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        DropDown.startListeningToKeyboard()
        
        dropDownEmitente.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.dropDownEmitente.hide()
            self.dropDownEmitenteBtn.setTitle("  \(item)", for: .normal)
            self.dropDownEmitenteBtn.backgroundColor = #colorLiteral(red: 0.00238864636, green: 0.4450881481, blue: 0.900737524, alpha: 1)
            self.dropDownEmitenteBtn.layer.cornerRadius = 5
            self.dropDownEmitenteBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.emitenteSelecionado = item
        }
        
        for emitente in emitentes{
            dropDownEmitente.dataSource.append(contentsOf: ["\(emitente.razaoSocial)"])
        }
        
        containerView.addSubview(dropDownEmitenteBtn)
        dropDownEmitente.anchorView = dropDownEmitenteBtn
        dropDownEmitenteBtn.translatesAutoresizingMaskIntoConstraints = false
        dropDownEmitente.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropDownEmitenteBtn.topAnchor.constraint(equalTo: dropDownContaBtn.bottomAnchor, constant: 20),
            dropDownEmitenteBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            dropDownEmitenteBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20)
        ])
        
    }
    @objc func selecionaEmitente() {
        dropDownEmitente.show()
    }
}

