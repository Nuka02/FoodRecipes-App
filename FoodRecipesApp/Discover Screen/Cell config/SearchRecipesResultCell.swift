import UIKit

class SearchRecipesResultCell: UITableViewCell {

    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeDescriptionLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
    }
    // MARK: - Helper Methods
    func configure(for result: SearchRecipesResult) {
        recipeNameLabel.text = result.recipe.label

        if ((result.recipe.label?.isEmpty) == nil) {
            recipeNameLabel.text = "Unknown"
        }
        else {
            recipeDescriptionLabel.text = String(format: "%@ (%@)", result.recipe.source!, (result.recipe.cuisineType.first!!).capitalizingFirstLetter())
        }
        recipeImageView.image = UIImage(systemName: "square")
        recipeImageView.layer.borderWidth = 2
        recipeImageView.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        recipeImageView.layer.cornerRadius = 5.0
        if let previewURL = URL(string: result.recipe.image!) {
          downloadTask = recipeImageView.loadImage(url: previewURL)
        }
    }
    func configure(for result: TrendingResults) {
        recipeNameLabel.text = result.recipe.label

        if ((result.recipe.label?.isEmpty) == nil) {
            recipeNameLabel.text = "Unknown"
        }
        else {
            recipeDescriptionLabel.text = String(format: "%@ (%@)", result.recipe.source!, (result.recipe.cuisineType.first!!).capitalizingFirstLetter())
        }
        recipeImageView.image = UIImage(systemName: "square")
        recipeImageView.layer.borderWidth = 2
        recipeImageView.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        recipeImageView.layer.cornerRadius = 5.0
        if let previewURL = URL(string: result.recipe.image!) {
          downloadTask = recipeImageView.loadImage(url: previewURL)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
