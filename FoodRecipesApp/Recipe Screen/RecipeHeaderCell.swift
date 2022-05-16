import UIKit

class RecipeHeaderCell: UITableViewCell {

    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var mealTypeLabel: UILabel!
    @IBOutlet weak var dishTypeLabel: UILabel!
    @IBOutlet weak var recipeView: UIView!
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: - Helper Methods
    func configure(for result: SearchRecipesResult) {
        //round border for recipe view
        recipeView.layer.cornerRadius = 10
        recipeView.clipsToBounds = true

        recipeView.layer.borderColor = UIColor.white.cgColor
        recipeView.layer.borderWidth = 2.0
        
        let cals = (result.recipe.calories! / Double(result.recipe.yield!))
        
        // bold recipe title
        recipeNameLabel.font = UIFont.boldSystemFont(ofSize: recipeNameLabel.font.pointSize)

        recipeNameLabel.text = result.recipe.label

        if ((result.recipe.label?.isEmpty) == nil) {
            recipeNameLabel.text = ""
        }
        
        cookTimeLabel.text = String(format:"%.0f", result.recipe.totalTime!) + " min"
        servingsLabel.text = String(format: "%.0f", result.recipe.yield!) + " servings"
        caloriesLabel.text = String(format:"%.0f", cals) + " calories"
        mealTypeLabel.text = (result.recipe.mealType.first as? String)?.capitalizingFirstLetter()
        if result.recipe.dietLabels.isEmpty{
            dishTypeLabel.text = ""
        }
        else{
            dishTypeLabel.text = (result.recipe.dishType.first as? String)?.capitalizingFirstLetter()
        }
        
        recipeImg.image = UIImage(systemName: "square")
        if let previewURL = URL(string: result.recipe.image!) {
          downloadTask = recipeImg.loadImage(url: previewURL)
        }
    }
    func configure(for result: TrendingResults) {
        // round border for recipe view
        recipeView.layer.cornerRadius = 10
        recipeView.clipsToBounds = true

        recipeView.layer.borderColor = UIColor.white.cgColor
        recipeView.layer.borderWidth = 2.0
        
        let cals = (result.recipe.calories! / Double(result.recipe.yield!))
        
        // bold recipe title
        recipeNameLabel.font = UIFont.boldSystemFont(ofSize: recipeNameLabel.font.pointSize)

        recipeNameLabel.text = result.recipe.label

        if ((result.recipe.label?.isEmpty) == nil) {
            recipeNameLabel.text = ""
        }
        
        cookTimeLabel.text = String(format:"%.0f", result.recipe.totalTime!) + " min"
        servingsLabel.text = String(format: "%.0f", result.recipe.yield!) + " servings"
        caloriesLabel.text = String(format:"%.0f", cals) + " calories"
        mealTypeLabel.text = (result.recipe.mealType.first as? String)?.capitalizingFirstLetter()
        if result.recipe.dishType.isEmpty{
            dishTypeLabel.text = ""
        }
        else{
            dishTypeLabel.text = (result.recipe.dishType.first as? String)?.capitalizingFirstLetter()
        }
 
        recipeImg.image = UIImage(systemName: "square")
        if let previewURL = URL(string: result.recipe.image!) {
          downloadTask = recipeImg.loadImage(url: previewURL)
        }
    }
    func configure(for result: RecommendationResults) {
        //round border for recipe view
        recipeView.layer.cornerRadius = 10
        recipeView.clipsToBounds = true

        recipeView.layer.borderColor = UIColor.white.cgColor
        recipeView.layer.borderWidth = 2.0
        
        let cals = (result.recipe.calories! / Double(result.recipe.yield!))
        
        // bold recipe title
        recipeNameLabel.font = UIFont.boldSystemFont(ofSize: recipeNameLabel.font.pointSize)

        recipeNameLabel.text = result.recipe.label

        if ((result.recipe.label?.isEmpty) == nil) {
            recipeNameLabel.text = ""
        }
        
        cookTimeLabel.text = String(format:"%.0f", result.recipe.totalTime!) + " min"
        var servings = ""
        if result.recipe.yield == 1.0{
            servings = " serving"
        }
        else{
            servings = " servings"
        }
        servingsLabel.text = String(format: "%.0f", result.recipe.yield!) + servings
        caloriesLabel.text = String(format:"%.0f", cals) + " calories"
        mealTypeLabel.text = (result.recipe.mealType.first as? String)?.capitalizingFirstLetter()
        if result.recipe.dietLabels.isEmpty{
            dishTypeLabel.text = ""
        }
        else{
            dishTypeLabel.text = (result.recipe.dishType.first as? String)?.capitalizingFirstLetter()
        }
        
        recipeImg.image = UIImage(systemName: "square")
        if let previewURL = URL(string: result.recipe.image!) {
          downloadTask = recipeImg.loadImage(url: previewURL)
        }
    }
}
