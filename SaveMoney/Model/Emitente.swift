//
//  Emitente.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 18/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class Emitente: Object {
    @objc dynamic var cnpjCPF: Int = 0
    @objc dynamic var razaoSocial: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var telefone: String = ""
    
    let receita = List<Receita>()
    let despesa = List<Despesa>()
}

