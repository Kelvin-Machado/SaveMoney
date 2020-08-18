//
//  Months.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 27/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

enum Months: Int, CustomStringConvertible {

case janeiro
case fevereiro
case marco
case abril
case maio
case junho
case julho
case agosto
case setembro
case outubro
case novembro
case dezembro

    var description: String {
        switch self {
        case .janeiro: return "Janeiro"
        case .fevereiro: return "Fevereiro"
        case .marco: return "Março"
        case .abril: return "Abril"
        case .maio: return "Maio"
        case .junho: return "Junho"
        case .julho: return "Julho"
        case .agosto: return "Agosto"
        case .setembro: return "Setembro"
        case .outubro: return "Outubro"
        case .novembro: return "Novembro"
        case .dezembro: return "Dezembro"
        }
    }
}

