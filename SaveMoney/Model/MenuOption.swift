//
//  MenuOption.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 20/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case cartao
    case emitente
    case conta
    case categoria
    case despesa
    case receita
    case orcamento
    case grafico
    case movimentacao
    
    var description: String {
        switch self {
        case .cartao: return "Cartão"
        case .emitente: return "Emitente"
        case .conta: return "Conta"
        case .categoria: return "Categoria"
        case .despesa: return "Despesa"
        case .receita: return "Receita"
        case .orcamento: return "Orçamento"
        case .grafico: return "Gráfico"
        case .movimentacao: return "Movimentação"
        }
    }
    
    var image: UIImage{
        switch self {
        case .cartao: return #imageLiteral(resourceName: "003-credit-card")
        case .emitente: return #imageLiteral(resourceName: "004-bill")
        case .conta: return #imageLiteral(resourceName: "005-cash-flow")
        case .categoria: return #imageLiteral(resourceName: "011-price")
        case .despesa: return #imageLiteral(resourceName: "010-deposit")
        case .receita: return #imageLiteral(resourceName: "009-business-and-finance")
        case .orcamento: return #imageLiteral(resourceName: "001-cost")
        case .grafico: return #imageLiteral(resourceName: "002-pie-chart")
        case .movimentacao: return #imageLiteral(resourceName: "007-money-flow")

        }
    }
}
