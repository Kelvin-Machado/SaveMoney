//
//  CategoriaController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriaController: UIViewController, UITextFieldDelegate {
    
    //    MARK: - Properties
    let realm = try! Realm()
    
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint!
    
    var tipoDespesa = true
    
    let despesasBtn = UIButton()
    let receitasBtn = UIButton()
    
    var novaCategoriaLbl = UILabel()
    var descricaoTxt = UITextField()
    
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
        configureCredito()
        configureDebito()
        configureDescricao()
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
    
    func configureCredito() {
        despesasBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        despesasBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1), for: UIControl.State.normal)
        despesasBtn.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        despesasBtn.setTitle("Despesas", for: .normal)
        
        despesasBtn.addTarget(self, action: #selector(despesasBtnTapped), for: .touchUpInside)
        
        containerView.addSubview(despesasBtn)
        
        despesasBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            despesasBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            despesasBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20)
        ])
    }
    @objc func despesasBtnTapped() {
        despesasBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1) , for: UIControl.State.normal)
        receitasBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        tipoDespesa = true
    }
    
    func configureDebito() {
        receitasBtn.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        receitasBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        receitasBtn.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        receitasBtn.setTitle("Receitas", for: .normal)
        
        receitasBtn.addTarget(self, action: #selector(receitasBtnTapped), for: .touchUpInside)
        
        containerView.addSubview(receitasBtn)
        
        receitasBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            receitasBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            receitasBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20)
        ])
    }
    
    @objc func receitasBtnTapped() {
        receitasBtn.setTitleColor( #colorLiteral(red: 0.0252066534, green: 0.3248851895, blue: 0.6532549858, alpha: 1), for: UIControl.State.normal)
        despesasBtn.setTitleColor( #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1), for: UIControl.State.normal)
        tipoDespesa = false
    }
    
    func configureDescricao() {
        novaCategoriaLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        novaCategoriaLbl.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        novaCategoriaLbl.text = "Criar nova categoria"
        novaCategoriaLbl.textColor = .black
        
        descricaoTxt.delegate = self
        descricaoTxt.keyboardType = .default
        descricaoTxt.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        descricaoTxt.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        descricaoTxt.textColor = .black
        descricaoTxt.attributedPlaceholder = NSAttributedString(string: "Descrição",
                                                                attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5575397611, green: 0.5729063153, blue: 0.6198518276, alpha: 1)])
        
        descricaoTxt.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 1.0)
        
        containerView.addSubview(novaCategoriaLbl)
        containerView.addSubview(descricaoTxt)
        novaCategoriaLbl.translatesAutoresizingMaskIntoConstraints = false
        descricaoTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            novaCategoriaLbl.topAnchor.constraint(equalTo: despesasBtn.bottomAnchor, constant: 20),
            novaCategoriaLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoTxt.topAnchor.constraint(equalTo: novaCategoriaLbl.bottomAnchor, constant: 20),
            descricaoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descricaoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30),
            descricaoTxt.widthAnchor.constraint(equalToConstant: containerView.frame.width - 60),
        ])
    }
    
    //    MARK: - Helper Functions
    
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        containerView.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "011-price").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Categoria"
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
        let categoria = Categoria()
        categoria.descricao = descricaoTxt.text!
        tipoDespesa ? (categoria.tipo = .despesa) : (categoria.tipo = .receita)
        save(novaCategoria: categoria)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Data Manipulation Methods
    func save(novaCategoria: Categoria) {
        let sucesso = true
        
        do {
            try realm.write {
                realm.add(novaCategoria)
                showAlert(sucesso: sucesso)
            }
        } catch {
            print("Error saving category \(error)")
            showAlert(sucesso: !sucesso)
        }
        showAlert(sucesso: !sucesso)
        
    }
    func showAlert(sucesso: Bool) {
        var msg = ""
        var titulo = ""
        sucesso ? (msg = "Categoria salva") : (msg = "Falha ao salvar categoria")
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


