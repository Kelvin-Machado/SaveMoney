//
//  Orcamento.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class Orcamento: Object {
    @objc dynamic var data: Date = Date()
    @objc dynamic var meta: Double = 0.0
    @objc dynamic var valorGasto: Double = 0.0
    @objc dynamic var valorPrevisto: Double = 0.0
    @objc dynamic var ativo: Bool = false
    
    var parentDespesas = LinkingObjects(fromType: Despesa.self, property: "orcamentos")
}
