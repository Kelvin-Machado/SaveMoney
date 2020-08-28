//
//  Conta.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import Foundation
import RealmSwift

enum tipoConta: String, CustomStringConvertible {
    case contaCorrente
    case cartao
    case dinheiro
    case cheque
    case contaPoupanca
    
    var description: String {
        switch self {
            case .contaCorrente: return "Conta Corrente"
            case .cartao: return "Cartão"
            case .dinheiro: return "Dinheiro"
            case .cheque: return "Cheque"
            case .contaPoupanca: return "Conta Poupança"
        }
    }
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
