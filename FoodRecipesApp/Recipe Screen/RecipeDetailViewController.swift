import UIKit

protocol RecipeDetailViewControllerDelegate: AnyObject {
    func addItemViewController(
    _ controller: RecipeDetailViewController,
    didFinishAdding item: TrendingResults)
    func addItemViewController(
    _ controller: RecipeDetailViewController,
    didFinishAdding item: SearchRecipesResult)
}

class RecipeDetailViewController: UITableViewController {
    var searchResult: SearchRecipesResult!
    var trendingResult: TrendingResults!
    var recommendedResult: RecommendationResults!

    weak var delegate: RecipeDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Helper Functions
    
    // directions button should take user to the selected recipe's page
    @IBAction func openInStore() {
        if(searchResult != nil)
        {
            if let url = URL(string: searchResult.recipe.url!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else if(trendingResult != nil){
            if let url = URL(string: trendingResult.recipe.url!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else{
            if let url = URL(string: recommendedResult.recipe.url!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Ingredients"
        }
        else if section == 2{
            return "Directions"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1){
            if (searchResult != nil){
                return searchResult.recipe.ingredientLines.count
            }
            else if(trendingResult != nil){
                return trendingResult.recipe.ingredientLines.count
            }
            else{
                return recommendedResult.recipe.ingredientLines.count
            }
        }
        else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeHeaderCell", for: indexPath) as! RecipeHeaderCell
            if (searchResult != nil){
                cell.configure(for: searchResult)
            }
            else if (trendingResult != nil){
                cell.configure(for: trendingResult)
            }
            else {
                cell.configure(for: recommendedResult)
            }
            return cell
        }
        else if indexPath.section == 1{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "IngredientsListCell", for: indexPath) as! IngredientsViewCell
            if (searchResult != nil){
                cell2.ingredientLabel!.text = searchResult.recipe.ingredientLines[indexPath.row]
            }
            else if (trendingResult != nil){
                cell2.ingredientLabel!.text = trendingResult.recipe.ingredientLines[indexPath.row]
            }
            else{
                cell2.ingredientLabel!.text = recommendedResult.recipe.ingredientLines[indexPath.row]
            }
            return cell2
        }
        else {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "DirectionsCell", for: indexPath) as! DirectionsViewCell
            if(searchResult != nil){
                cell3.configure(for: searchResult)
            }
            else if(trendingResult != nil){
                cell3.configure(for: trendingResult)
            }
            else{
                cell3.configure(for: recommendedResult)
            }
            return cell3
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return nil
    }
}
