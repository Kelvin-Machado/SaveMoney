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
    private var tipo: tipoDocumento?
    
    var tipoEnum: tipoDocumento? {
        get {
            if let resolTypeRaw = tipoEnumRaw  {
                tipo = tipoDocumento(rawValue: resolTypeRaw)
                return tipo
            }
            return .receita
        }
        set {
            tipoEnumRaw = newValue?.rawValue
            tipo = newValue
        }
    }
    dynamic var tipoEnumRaw: String? = nil

    var parentReceita = LinkingObjects(fromType: Receita.self, property: "categorias")
    var parentDespesa = LinkingObjects(fromType: Despesa.self, property: "categorias")
}
