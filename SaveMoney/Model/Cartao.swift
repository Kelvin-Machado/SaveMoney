//
//  Cartao.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 27/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

enum tipoCartao: String {
    case debito
    case credito
}

class Cartao: Object {
    @objc dynamic var cartaoId: Int64 = 0
    @objc dynamic var nomeCartao: String = ""
    @objc dynamic var numeroCartao: String = ""
    @objc dynamic var dataVencimento: Date = Date()
    private var tipo: tipoCartao?

    var tipoEnum: tipoCartao? {
        get {
            if let resolTypeRaw = tipoEnumRaw  {
                tipo = tipoCartao(rawValue: resolTypeRaw)
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
    var parentConta = LinkingObjects(fromType: Conta.self, property: "cartoes")
}
