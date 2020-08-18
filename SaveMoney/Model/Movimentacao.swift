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
    case debito
    case credito
}

class Movimentacao: Object {
    @objc dynamic var dataMovimentacao: Date = Date()
    @objc dynamic var valorMovimento: Double = 0.0
    private var tipo: tipoMovimentacao?

    var tipoEnum: tipoMovimentacao? {
        get {
            if let resolTypeRaw = tipoEnumRaw  {
                tipo = tipoMovimentacao(rawValue: resolTypeRaw)
                return tipo
            }
            return .credito
        }
        set {
            tipoEnumRaw = newValue?.rawValue
            tipo = newValue
        }
    }
    dynamic var tipoEnumRaw: String? = nil
    var parentConta = LinkingObjects(fromType: Conta.self, property: "movimentacoes")
}

