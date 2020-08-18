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
    @objc dynamic var numero: Int = 0
    @objc dynamic var nomeBanco: String = ""
    @objc dynamic var saldo: Double = 0.0
    private var tipo: tipoConta?

    var tipoEnum: tipoConta? {
        get {
            if let resolTypeRaw = tipoEnumRaw  {
                tipo = tipoConta(rawValue: resolTypeRaw)
                return tipo
            }
            return .contaCorrente
        }
        set {
            tipoEnumRaw = newValue?.rawValue
            tipo = newValue
        }
    }
    dynamic var tipoEnumRaw: String? = nil

    let cartoes = List<Cartao>()
    let movimentacoes = List<Movimentacao>()
    let receita = List<Receita>()
    let despesa = List<Despesa>()
}
