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
    var categorias = [Categoria]()
    var meta = [Orcamento]()
    
    let periodo = Date()
    let calendar = Calendar.current
    var mesAtual = 0
    
    var visaoGeralLbl = UILabel()
    var saldo = 0.0
    var despesaMes = 0.0
    var receitaMes = 0.0
    var saldoLbl = UILabel()
    var saldoValorLbl = UILabel()
    var receitaLbl = UILabel()
    var receitaValorLbl = UILabel()
    var despesaLbl = UILabel()
    var despesaValorLbl = UILabel()
    
    var orcamentoLbl = UILabel()
    var metaLbl = UILabel()
    var metaValorLb = UILabel()
    var gastoLbl = UILabel()
    var valorGastoLbl = UILabel()
    var restoValorLbl = UILabel()
    
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
        
        mesAtual = calendar.component(.month, from: periodo)
        
        carregarDados()
        carregarDadosGrafico()
        
        configureNavigationBar()
        configureVisaoGeral()
        configureOrcamento()
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
        
        containerGeralView.layer.shadowColor = UIColor.flatNavyBlue().cgColor
        containerGeralView.layer.shadowOpacity = 0.5
        containerGeralView.layer.shadowOffset = .zero
        containerGeralView.layer.shadowRadius = 2
        containerGeralView.backgroundColor =  #colorLiteral(red: 0.8801595569, green: 0.9066320062, blue: 1, alpha: 1)
        
        visaoGeralLbl.text = "Visão Geral - \(Months.init(rawValue: mesAtual-1)!)"
        visaoGeralLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        visaoGeralLbl.backgroundColor = .clear
        visaoGeralLbl.textColor = .flatNavyBlueDark()
        
        receitaLbl.text = "Receitas"
        receitaLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        receitaLbl.backgroundColor = .clear

        receitaValorLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        receitaValorLbl.backgroundColor = .clear
        receitaValorLbl.textAlignment = .right
        
        despesaLbl.text = "Despesas"
        despesaLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        despesaLbl.backgroundColor = .clear
        
        despesaValorLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        despesaValorLbl.backgroundColor = .clear
        despesaValorLbl.textAlignment = .right
        
        saldoLbl.text = "Saldo"
        saldoLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        saldoLbl.backgroundColor = .clear
        
        saldoValorLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        saldoValorLbl.backgroundColor = .clear
        saldoValorLbl.textAlignment = .right
        
        containerGeralView.translatesAutoresizingMaskIntoConstraints = false
        visaoGeralLbl.translatesAutoresizingMaskIntoConstraints = false
        receitaLbl.translatesAutoresizingMaskIntoConstraints = false
        receitaValorLbl.translatesAutoresizingMaskIntoConstraints = false
        despesaLbl.translatesAutoresizingMaskIntoConstraints = false
        despesaValorLbl.translatesAutoresizingMaskIntoConstraints = false
        saldoLbl.translatesAutoresizingMaskIntoConstraints = false
        saldoValorLbl.translatesAutoresizingMaskIntoConstraints = false
        
        containerGeralView.addSubview(visaoGeralLbl)
        containerGeralView.addSubview(receitaLbl)
        containerGeralView.addSubview(receitaValorLbl)
        containerGeralView.addSubview(despesaLbl)
        containerGeralView.addSubview(despesaValorLbl)
        containerGeralView.addSubview(saldoLbl)
        containerGeralView.addSubview(saldoValorLbl)
        view.addSubview(containerGeralView)
        
        NSLayoutConstraint.activate([
            
            containerGeralView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            containerGeralView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerGeralView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerGeralView.heightAnchor.constraint(equalToConstant: (view.frame.height - 150) * 0.3),
            
            visaoGeralLbl.rightAnchor.constraint(equalTo: containerGeralView.rightAnchor, constant: -10),
            visaoGeralLbl.topAnchor.constraint(equalTo: containerGeralView.topAnchor, constant: 10),
            visaoGeralLbl.leftAnchor.constraint(equalTo: containerGeralView.leftAnchor, constant: 10),
            
            receitaLbl.leftAnchor.constraint(equalTo: containerGeralView.leftAnchor, constant: 10),
            receitaLbl.topAnchor.constraint(equalTo: visaoGeralLbl.bottomAnchor, constant: 20),
            
            receitaValorLbl.rightAnchor.constraint(equalTo: containerGeralView.rightAnchor, constant: -10),
            receitaValorLbl.topAnchor.constraint(equalTo: visaoGeralLbl.bottomAnchor, constant: 20),
            receitaValorLbl.leftAnchor.constraint(equalTo: receitaLbl.rightAnchor, constant: 10),
            
            despesaLbl.leftAnchor.constraint(equalTo: containerGeralView.leftAnchor, constant: 10),
            despesaLbl.topAnchor.constraint(equalTo: receitaLbl.bottomAnchor, constant: 10),
            
            despesaValorLbl.rightAnchor.constraint(equalTo: containerGeralView.rightAnchor, constant: -10),
            despesaValorLbl.topAnchor.constraint(equalTo: receitaValorLbl.bottomAnchor, constant: 10),
            despesaValorLbl.leftAnchor.constraint(equalTo: despesaLbl.rightAnchor, constant: 10),
            
            saldoLbl.leftAnchor.constraint(equalTo: containerGeralView.leftAnchor, constant: 10),
            saldoLbl.topAnchor.constraint(equalTo: despesaLbl.bottomAnchor, constant: 10),
            
            saldoValorLbl.rightAnchor.constraint(equalTo: containerGeralView.rightAnchor, constant: -10),
            saldoValorLbl.topAnchor.constraint(equalTo: despesaValorLbl.bottomAnchor, constant: 10),
            saldoValorLbl.leftAnchor.constraint(equalTo: saldoLbl.rightAnchor, constant: 10),
            
        ])
    }
    
    func configureOrcamento() {
        
        containerOrcamentoView.layer.shadowColor = UIColor.flatNavyBlue().cgColor
        containerOrcamentoView.layer.shadowOpacity = 0.5
        containerOrcamentoView.layer.shadowOffset = .zero
        containerOrcamentoView.layer.shadowRadius = 2
        containerOrcamentoView.backgroundColor =  #colorLiteral(red: 0.8801595569, green: 0.9066320062, blue: 1, alpha: 1)
        
        orcamentoLbl.text = "Orçamento - \(Months.init(rawValue: mesAtual-1)!)"
        orcamentoLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        orcamentoLbl.backgroundColor = .clear
        orcamentoLbl.textColor = .flatNavyBlueDark()
        
        metaLbl.text = "Meta"
        metaLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        metaLbl.backgroundColor = .clear

        metaValorLb.font = UIFont(name:"HelveticaNeue", size: 14)
        metaValorLb.backgroundColor = .clear
        metaValorLb.textAlignment = .right
        
        gastoLbl.text = "Valor gasto"
        gastoLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        gastoLbl.backgroundColor = .clear
        
        valorGastoLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        valorGastoLbl.backgroundColor = .clear
        valorGastoLbl.textAlignment = .right
        
        restoValorLbl.font = UIFont(name:"HelveticaNeue", size: 14)
        restoValorLbl.backgroundColor = .clear
        restoValorLbl.textAlignment = .center
        
        containerOrcamentoView.translatesAutoresizingMaskIntoConstraints = false
        orcamentoLbl.translatesAutoresizingMaskIntoConstraints = false
        metaLbl.translatesAutoresizingMaskIntoConstraints = false
        metaValorLb.translatesAutoresizingMaskIntoConstraints = false
        gastoLbl.translatesAutoresizingMaskIntoConstraints = false
        valorGastoLbl.translatesAutoresizingMaskIntoConstraints = false
        restoValorLbl.translatesAutoresizingMaskIntoConstraints = false
        
        containerOrcamentoView.addSubview(orcamentoLbl)
        containerOrcamentoView.addSubview(metaLbl)
        containerOrcamentoView.addSubview(metaValorLb)
        containerOrcamentoView.addSubview(gastoLbl)
        containerOrcamentoView.addSubview(valorGastoLbl)
        containerOrcamentoView.addSubview(restoValorLbl)
        view.addSubview(containerOrcamentoView)
        
        NSLayoutConstraint.activate([
            containerOrcamentoView.topAnchor.constraint(equalTo: containerGeralView.bottomAnchor, constant: 20),
            containerOrcamentoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerOrcamentoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerOrcamentoView.heightAnchor.constraint(equalToConstant: (view.frame.height - 150) * 0.3),
            
            orcamentoLbl.rightAnchor.constraint(equalTo: containerOrcamentoView.rightAnchor, constant: -10),
            orcamentoLbl.topAnchor.constraint(equalTo: containerOrcamentoView.topAnchor, constant: 10),
            orcamentoLbl.leftAnchor.constraint(equalTo: containerOrcamentoView.leftAnchor, constant: 10),
            
            metaLbl.leftAnchor.constraint(equalTo: containerOrcamentoView.leftAnchor, constant: 10),
            metaLbl.topAnchor.constraint(equalTo: orcamentoLbl.bottomAnchor, constant: 20),
            
            metaValorLb.rightAnchor.constraint(equalTo: containerOrcamentoView.rightAnchor, constant: -10),
            metaValorLb.topAnchor.constraint(equalTo: orcamentoLbl.bottomAnchor, constant: 20),
            metaValorLb.leftAnchor.constraint(equalTo: metaLbl.rightAnchor, constant: 10),
            
            gastoLbl.leftAnchor.constraint(equalTo: containerOrcamentoView.leftAnchor, constant: 10),
            gastoLbl.topAnchor.constraint(equalTo: metaLbl.bottomAnchor, constant: 10),
            
            valorGastoLbl.rightAnchor.constraint(equalTo: containerOrcamentoView.rightAnchor, constant: -10),
            valorGastoLbl.topAnchor.constraint(equalTo: metaValorLb.bottomAnchor, constant: 10),
            valorGastoLbl.leftAnchor.constraint(equalTo: gastoLbl.rightAnchor, constant: 10),
            
            restoValorLbl.centerXAnchor.constraint(equalTo: containerOrcamentoView.centerXAnchor),
            restoValorLbl.topAnchor.constraint(equalTo: valorGastoLbl.bottomAnchor, constant: 20),
        ])
    }
    func carregarDados() {
        receitas = Array(realm.objects(Receita.self))
        despesas = Array(realm.objects(Despesa.self))
        
        for receita in receitas {
            if periodo.startOfMonth == receita.dataLancamento.startOfMonth {
                receitaMes += receita.valorReceita
                saldo += receita.valorReceita
            }
        }
        
        for despesa in despesas {
            if periodo.startOfMonth == despesa.dataVencimento.startOfMonth {
                despesaMes += despesa.valorDespesa
                saldo -= despesa.valorDespesa
                meta.append(contentsOf: despesa.orcamentos)
            }
        }
        
        receitaValorLbl.text = "R$ \(receitaMes)"
        despesaValorLbl.text = "R$ \(despesaMes)"
        
        valorGastoLbl.text = "R$ \(despesaMes)"
        metaValorLb.text = "R$ \(meta[0].meta)"
        restoValorLbl.text = "Restam R$ \(meta[0].meta - despesaMes)"
        
        saldoValorLbl.text = "R$ \(saldo.roundToDecimal(2))"
    }
    
    func carregarDadosGrafico() {
        
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
        
        containerChartView.layer.shadowColor = UIColor.flatNavyBlue().cgColor
        containerChartView.layer.shadowOpacity = 0.5
        containerChartView.layer.shadowOffset = .zero
        containerChartView.layer.shadowRadius = 2
        containerChartView.backgroundColor =  #colorLiteral(red: 0.8801595569, green: 0.9066320062, blue: 1, alpha: 1)
        
        chartLbl.text = "Despesas por categoria - \(Months.init(rawValue: mesAtual-1)!)"
        chartLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        chartLbl.backgroundColor = .clear
        chartLbl.textColor = .flatNavyBlueDark()
        
        containerChartView.translatesAutoresizingMaskIntoConstraints = false
        chartLbl.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        containerChartView.addSubview(chartLbl)
        containerChartView.addSubview(pieChartView)
        view.addSubview(containerChartView)
        
        NSLayoutConstraint.activate([
            containerChartView.topAnchor.constraint(equalTo: containerOrcamentoView.bottomAnchor, constant: 20),
            containerChartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerChartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerChartView.heightAnchor.constraint(equalToConstant: (view.frame.height - 150) * 0.4),
            
            chartLbl.rightAnchor.constraint(equalTo: containerChartView.rightAnchor, constant: -10),
            chartLbl.topAnchor.constraint(equalTo: containerChartView.topAnchor, constant: 10),
            chartLbl.leftAnchor.constraint(equalTo: containerChartView.leftAnchor, constant: 10),
            
            pieChartView.rightAnchor.constraint(equalTo: containerChartView.rightAnchor, constant: -10),
            pieChartView.topAnchor.constraint(equalTo: chartLbl.bottomAnchor, constant: 10),
            pieChartView.bottomAnchor.constraint(equalTo: containerChartView.bottomAnchor, constant: -10),
            pieChartView.leftAnchor.constraint(equalTo: containerChartView.leftAnchor, constant: 10)
        ])
    }
    
}
