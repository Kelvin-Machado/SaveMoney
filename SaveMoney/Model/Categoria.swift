//
//  Categoria.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import Foundation
import RealmSwift

enum tipoDocumento: String {
    case despesa
    case receita
}

class Categoria: Object {
    @objc dynamic var descricao: String = ""
    //    private dynamic var tipo: tipoDocumento?
    @objc dynamic var tipoRaw = tipoDocumento.despesa.rawValue
    var tipo: tipoDocumento {
        get {
            return tipoDocumento(rawValue: tipoRaw)!
        }
        set {
            tipoRaw = newValue.rawValue
        }
    }
    
    var parentReceita = LinkingObjects(fromType: Receita.self, property: "categorias")
    var parentDespesa = LinkingObjects(fromType: Despesa.self, property: "categorias")
}
