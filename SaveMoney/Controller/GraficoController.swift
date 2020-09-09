//
//  GraficoController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift
import Charts

class GraficoController: UIViewController, UITextFieldDelegate, ChartViewDelegate {
    
    //    MARK: - Properties
    
    let realm = try! Realm()
    var categorias = [Categoria]()
    
    var saldo = 0.0
    
    var periodo = Date()
    let dateFormat: DateFormatter = {
        let data = DateFormatter()
        data.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        data.dateStyle = .long
        return data
    }()
    
    lazy var periodoTxt: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Escolha o período"
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
    
    lazy var pieChartView: PieChartView = {
        let pieView = PieChartView()
        pieView.drawEntryLabelsEnabled = true
        pieView.drawHoleEnabled = false
        pieView.rotationEnabled = true
        pieView.usePercentValuesEnabled = true
        pieView.isUserInteractionEnabled = true
        
        return pieView
    }()
    
    var entries: [PieChartDataEntry] = Array()
    
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        return view
    }()
    
    //    MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.periodoTxt.text = dateFormat.string(from: periodo)
        
        carregarDados()
        configureNavigation()
        configureContainer()
        configurePeriodo()
        configurePieChart()
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
    func configurePeriodo() {
        periodoTxt.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(periodoTxt)
        
        periodoTxt.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        periodoTxt.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        periodoTxt.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
    }
    
    func configurePieChart() {
        
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pieChartView)
        
        NSLayoutConstraint.activate([
            pieChartView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            pieChartView.topAnchor.constraint(equalTo: periodoTxt.bottomAnchor, constant: 40),
            pieChartView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40),
            pieChartView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10)
        ])
    }
    
    //    MARK: - Helper Functions
    
    func configureNavigation() {
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        //put image on navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "002-pie-chart").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Gráfico"
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
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func selecionaData(sender: UIDatePicker){
        periodo = sender.date
        self.periodoTxt.text = dateFormat.string(from: sender.date)
        
        carregarDados()
    }

    // MARK: - Data Manipulation Methods
    
    func carregarDados() {
        entries.removeAll()
        
        categorias = Array(realm.objects(Categoria.self))
        
        for categoria in categorias {
            if categoria.tipo == .despesa {
                var valorGastoCategoria = 0.0
                for despesa in categoria.despesas {
                    if periodo.startOfMonth == despesa.dataVencimento.startOfMonth {
                        valorGastoCategoria += despesa.valorDespesa
                    }
                }
                
                if valorGastoCategoria > 0.0 {
                    entries.append(PieChartDataEntry(value: valorGastoCategoria, label: categoria.descricao))
                }
            }
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        var colors =  [NSUIColor]()
        var valueColors =  [NSUIColor]()
        for n in 0...entries.count {
            colors.append(NSUIColor(hexString: UIColor.randomFlat().hexValue())!)
            valueColors.append(ContrastColorOf(colors[n], returnFlat: true))
        }

        dataSet.colors = colors
        dataSet.valueColors = valueColors
        dataSet.entryLabelColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.drawValuesEnabled = true
        dataSet.sliceSpace = 2
        dataSet.selectionShift = 50
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        

        pieChartView.data = PieChartData(dataSet: dataSet)
        pieChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.animate(xAxisDuration: 1.5)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
