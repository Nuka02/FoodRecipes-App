//
//  DirectionsViewCell.swift
//  FoodRecipesApp
//
//  Created by Ajdin on 11. 5. 2022..
//

import UIKit

class DirectionsViewCell: UITableViewCell {

    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(for result: SearchRecipesResult) {
        directionsButton.layer.cornerRadius = 5
        sourceLabel.text = result.recipe.source
    }
    func configure(for result: TrendingResults) {
        directionsButton.layer.cornerRadius = 5
        sourceLabel.text = result.recipe.source
    }
    func configure(for result: RecommendationResults) {
        directionsButton.layer.cornerRadius = 5
        sourceLabel.text = result.recipe.source
    }
}

