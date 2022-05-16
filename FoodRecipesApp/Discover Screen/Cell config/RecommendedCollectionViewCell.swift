//
//  RecommendedCollectionViewCell.swift
//  FoodRecipesApp
//
//  Created by Ajdin on 11. 5. 2022..
//

import UIKit


class RecommendedCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var mealTypeLabel: UILabel!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply rounded corners
        contentView.layer.cornerRadius = 15.0
        contentView.layer.masksToBounds = true
    }
    
    
    func configure(for result: RecommendationResults){
        
        recipeNameLabel.text = result.recipe.label
        
        if ((result.recipe.label?.isEmpty) == nil) {
            recipeNameLabel.text = "Unknown"
        }
        mealTypeLabel.text = (result.recipe.mealType.first as? String)?.capitalizingFirstLetter()
        sourceLabel.text = result.recipe.source
        
        recipeImg.image = UIImage(systemName: "square")
        if let previewURL = URL(string: result.recipe.image!) {
            downloadTask = recipeImg.loadImage(url: previewURL)
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
