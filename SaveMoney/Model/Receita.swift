//
//  Receita.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class Receita: Object {
    @objc dynamic var dataLancamento: Date = Date()
    @objc dynamic var descricao: String = ""
    @objc dynamic var valorReceita: Double = 0.0
    @objc dynamic var aReceber: Bool = true
    
    var parentConta = LinkingObjects(fromType: Conta.self, property: "receitas")
    var parentEmitente = LinkingObjects(fromType: Emitente.self, property: "receitas")
    var parentCategoria = LinkingObjects(fromType: Categoria.self, property: "receitas")
}
