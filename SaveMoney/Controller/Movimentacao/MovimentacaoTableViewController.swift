//
//  MovimentacaoTableViewController.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 31/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class MovimentacaoTableViewController: UITableViewController {
    
    //    MARK: - Properties
    var numElem: Int = 1
    var movimentArray = [Movimentacao]()

    let realm = try! Realm()
    var receitas = [Receita]()
    var despesas = [Despesa]()
    
    var saldo = 0.0
    
    //    MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carregarDados()
        tableView.delegate = self
        footer()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Lista de Movimentações"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
        headerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numElem
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MovimentacaoTableViewCell", owner: self, options: nil)?.first as! MovimentacaoTableViewCell
        
        cell.backgroundColor =  #colorLiteral(red: 0.8384380937, green: 0.9086549282, blue: 1, alpha: 1)
        cell.selectionStyle = .none
        
        if movimentArray[indexPath.row].tipoRaw == "despesa" {
            cell.descricaoLbl.text = movimentArray[indexPath.row].descricao
            cell.valorLbl.text = "- R$ \(movimentArray[indexPath.row].valorMovimento)"
            cell.descricaoLbl.textColor = .red
            cell.valorLbl.textColor = .red
        } else {
            cell.descricaoLbl.text = movimentArray[indexPath.row].descricao
            cell.valorLbl.text = "+ R$ \(movimentArray[indexPath.row].valorMovimento)"
            cell.descricaoLbl.textColor = #colorLiteral(red: 0, green: 0.4639702439, blue: 0, alpha: 1)
            cell.valorLbl.textColor = #colorLiteral(red: 0, green: 0.4639702439, blue: 0, alpha: 1)
        }
        return cell
    }
    
    func footer() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let saldoLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        saldoLbl.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        if saldo < 0 {
            customView.backgroundColor = UIColor.red
            saldoLbl.textColor = .white
            saldoLbl.text = "  Saldo: - R$ \(saldo)"
        } else if saldo > 0 {
            customView.backgroundColor = #colorLiteral(red: 0, green: 0.4639702439, blue: 0, alpha: 1)
            saldoLbl.textColor = .white
            saldoLbl.text = "  Saldo: + R$ \(saldo)"
        } else {
            customView.backgroundColor = .black
            saldoLbl.textColor = .white
            saldoLbl.text = " Sem dados aqui 🧐"
        }
        
        customView.addSubview(saldoLbl)
        
        tableView.tableFooterView = customView
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func carregarDados() {
        movimentArray.removeAll()
        
        receitas = Array(realm.objects(Receita.self))
        despesas = Array(realm.objects(Despesa.self))
        
        for receita in receitas {

            let mov = Movimentacao()
            mov.dataMovimentacao = receita.dataLancamento
            mov.tipo = .receita
            mov.valorMovimento = receita.valorReceita
            mov.descricao = receita.descricao
            saldo += receita.valorReceita
            movimentArray.append(mov)
        }

        for despesa in despesas {
            let mov = Movimentacao()
            mov.dataMovimentacao = despesa.dataVencimento
            mov.tipo = .despesa
            mov.valorMovimento = despesa.valorDespesa
            mov.descricao = despesa.descricao
            saldo -= despesa.valorDespesa
            movimentArray.append(mov)
        }
        movimentArray.sort(by: { $0.dataMovimentacao.compare($1.dataMovimentacao) == .orderedAscending })
        
        numElem = receitas.count + despesas.count
    }
}
