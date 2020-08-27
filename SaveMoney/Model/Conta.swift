//
//  Conta.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import Foundation
import RealmSwift

enum tipoConta: String {
    case contaCorrente
    case cartao
    case dinheiro
    case cheque
    case contaPoupanca
}

class Conta: Object {
    @objc dynamic var contaId: Int64 = 0
    @objc dynamic var numero: String = ""
    @objc dynamic var nomeBanco: String = ""
    @objc dynamic var saldo: Double = 0.0
    
    @objc dynamic var tipoRaw = tipoConta.contaCorrente.rawValue
    var tipo: tipoConta {
        get {
            return tipoConta(rawValue: tipoRaw)!
        }
        set {
            tipoRaw = newValue.rawValue
        }
    }

    let cartoes = List<Cartao>()
    let movimentacoes = List<Movimentacao>()
    let receitas = List<Receita>()
    let despesas = List<Despesa>()
    
    override class func primaryKey() -> String? {
        return "contaId"
    }
}
