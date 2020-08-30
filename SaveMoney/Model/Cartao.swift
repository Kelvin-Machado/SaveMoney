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
    @objc dynamic var dataVencimento: Date? = Date()

    @objc dynamic var tipoRaw = tipoCartao.credito.rawValue
    var tipo: tipoCartao {
        get {
            return tipoCartao(rawValue: tipoRaw)!
        }
        set {
            tipoRaw = newValue.rawValue
        }
    }
    
    var parentConta = LinkingObjects(fromType: Conta.self, property: "cartoes")
}
