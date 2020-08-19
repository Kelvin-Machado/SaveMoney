//
//  Despesa.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class Despesa: Object {
    @objc dynamic var dataLancamento: Date = Date()
    @objc dynamic var descricao: String = ""
    @objc dynamic var dataVencimento: Date = Date()
    @objc dynamic var aPagar: Bool = true
    
    let categoria = List<Categoria>()
    let orcamentos = List<Orcamento>()
    
    var parentConta = LinkingObjects(fromType: Conta.self, property: "despesa")
    var parentEmitente = LinkingObjects(fromType: Emitente.self, property: "despesa")
}