//
//  MovimentacaoTableViewCell.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 01/09/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class MovimentacaoTableViewCell: UITableViewCell {

    @IBOutlet weak var descricaoLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
