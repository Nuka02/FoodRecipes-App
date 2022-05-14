//
//  RestrictionsTableViewCell.swift
//  FoodRecipesApp
//
//  Created by Ajdin on 12. 5. 2022..
//

import UIKit

class RestrictionsTableViewCell: UITableViewCell {
    @IBOutlet weak var restrictionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configures(for result: String){
        restrictionsLabel.text  = result
    }

}
