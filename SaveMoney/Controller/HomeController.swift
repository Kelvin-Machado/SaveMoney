//
//  HomeController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 19/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//
// Icons made by https://www.flaticon.com/authors/freepik - Freepik from https://www.flaticon.com/

import UIKit
import ChameleonFramework
import RealmSwift
import Charts

class HomeController: UIViewController {
    
    //        MARK: - Properties
    var delegate: HomeControllerDelegate?
    
    let realm = try! Realm()
    var receitas = [Receita]()
    var despesas = [Despesa]()
    
    var orcamento = [Orcamento]()
    
    var categorias = [Categoria]()
    
    var visaoGeralLbl = UILabel()
    var contasLbl = UILabel()
    var contaValorLbl = UILabel()
    var receitaLbl = UILabel()
    var receitaValorLbl = UILabel()
    var despesaLbl = UILabel()
    var despesaValorLbl = UILabel()
    
    var orcamentoLbl = UILabel()
    var metaLbl = UILabel()
    var metaValorLb = UILabel()
    var gastoLbl = UILabel()
    var valorGastoLbl = UILabel()
    var previstoLbl = UILabel()
    var valorPrevistoLbl = UILabel()
    
    var chartLbl = UILabel()
    
    var containerGeralView: UIView = {
        let view = UIView()
        return view
    }()
    
    var containerOrcamentoView: UIView = {
        let view = UIView()
        return view
    }()
    
    var containerChartView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var pieChartView: PieChartView = {
        let pieView = PieChartView()
        pieView.legend.enabled = false
        pieView.drawEntryLabelsEnabled = true
        pieView.drawHoleEnabled = false
        pieView.rotationEnabled = true
        pieView.usePercentValuesEnabled = true
        pieView.isUserInteractionEnabled = true
        
        return pieView
    }()
    
    var entries: [PieChartDataEntry] = Array()
    
    //        MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        configureNavigationBar()
        configureVisaoGeral()
        configureOrcamento()
        carregarDados()
        configureChart()
    }
    
    //        MARK: - Handlers
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4490886927, blue: 0.9007502794, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = "Principal"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0.4033691883, blue: 0.5260575414, alpha: 1),
            NSAttributedString.Key.font:UIFont(name:"HelveticaNeue-Bold", size: 28)!,
            NSAttributedString.Key.strokeWidth : -2.0
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
    }
    
    func configureVisaoGeral() {
        containerGeralView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerGeralView)
        
        containerGeralView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            containerGeralView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            containerGeralView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerGeralView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerGeralView.heightAnchor.constraint(equalToConstant: (view.frame.height - 150) * 0.3)
        ])
    }
    
    func configureOrcamento() {
        containerOrcamentoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerOrcamentoView)
        
        containerOrcamentoView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            containerOrcamentoView.topAnchor.constraint(equalTo: containerGeralView.bottomAnchor, constant: 20),
            containerOrcamentoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerOrcamentoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerOrcamentoView.heightAnchor.constraint(equalToConstant: (view.frame.height - 150) * 0.3)
        ])
    }
    
    func carregarDados() {
        entries.removeAll()
        let periodo = Date()
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
        dataSet.sliceSpace = 1
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        

        pieChartView.data = PieChartData(dataSet: dataSet)
        pieChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.animate(xAxisDuration: 1.5)
    }
    
    func configureChart() {
        containerChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        containerChartView.addSubview(pieChartView)
        view.addSubview(containerChartView)
        
        containerChartView.backgroundColor =  #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        
        NSLayoutConstraint.activate([
            containerChartView.topAnchor.constraint(equalTo: containerOrcamentoView.bottomAnchor, constant: 20),
            containerChartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerChartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerChartView.heightAnchor.constraint(equalToConstant: (view.frame.height - 150) * 0.4),
            
            pieChartView.rightAnchor.constraint(equalTo: containerChartView.rightAnchor, constant: -10),
            pieChartView.topAnchor.constraint(equalTo: containerChartView.topAnchor, constant: 10),
            pieChartView.bottomAnchor.constraint(equalTo: containerChartView.bottomAnchor, constant: -10),
            pieChartView.leftAnchor.constraint(equalTo: containerChartView.leftAnchor, constant: 10)
        ])
    }
    
}
