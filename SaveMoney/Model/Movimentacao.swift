//
//  Movimentacao.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

enum tipoMovimentacao: String {
    case despesa
    case receita
}

class Movimentacao: Object {
    @objc dynamic var dataMovimentacao: Date = Date()
    @objc dynamic var valorMovimento: Double = 0.0
    @objc dynamic var descricao: String = ""
    
    @objc dynamic var tipoRaw = tipoMovimentacao.despesa.rawValue
    var tipo: tipoMovimentacao {
        get {
            return tipoMovimentacao(rawValue: tipoRaw)!
        }
        set {
            tipoRaw = newValue.rawValue
        }
    }
    
    var parentConta = LinkingObjects(fromType: Conta.self, property: "movimentacoes")
}

