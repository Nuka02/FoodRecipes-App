//
//  IngredientsViewCell.swift
//  FoodRecipesApp
//
//  Created by Ajdin on 11. 5. 2022..
//

import UIKit

class IngredientsViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
