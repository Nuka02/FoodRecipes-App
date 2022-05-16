import UIKit



class SearchRecipesViewController: UIViewController, RestrictionsControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    func restrictionsController(_ controller: RestrictionsTableViewController, didFinishAdding item: [ChecklistItem]) {
        restrictions = item
        searchNow()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func restrictionsControllerDidCancel(_ controller: RestrictionsTableViewController) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    var searchResults = [SearchRecipesResult]() //  array for data
    var trendingResults = [TrendingResults]()
    var recommendedResults = [RecommendationResults]()
    var searchResultText = ""
    var hasSearched = false
    var isLoading = false
    var restrictions = [ChecklistItem]()
    var dataTask: URLSessionDataTask?
    
    var config: [String: Any]?
    
    
    struct TableView {
        struct CellIdentifiers {
            static let searchRecipesResultCell = "SearchRecipesResultCell"
            static let noRecipesFoundCell = "NoRecipesFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Food Recipes"
        registerDefaults()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.becomeFirstResponder() // dismiss keyboard
        searchBar.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchRecipesResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchRecipesResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.noRecipesFoundCell, bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: TableView.CellIdentifiers.noRecipesFoundCell)
        
        cellNib = UINib(
            nibName: TableView.CellIdentifiers.loadingCell,
            bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        if !hasSearched {
            recommendedResults = RecommendationRecipes.recommendationRecipes()
            trendingResults = TrendingRecipes.trendingRecipies()
        }
    }
    // MARK: - Navigation Controller Delegates
    func registerDefaults() {
        let dictionary = [ "RecipesIndex": -1 ]
        UserDefaults.standard.register(defaults: dictionary)
        
        let dictionary2 = [ "RecipesSection": -1 ]
        UserDefaults.standard.register(defaults: dictionary2)
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        // Was the back button tapped?
        if viewController === self {
            UserDefaults.standard.set(-1, forKey: "RecipesIndex")
            UserDefaults.standard.set(-1, forKey: "RecipesSection")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = UserDefaults.standard.integer(
            forKey: "RecipesIndex")
        let sections = UserDefaults.standard.integer(
            forKey: "RecipesSection")
        
        
        //        if index >= 0 && index < trendingResults.count || index >= 0 && index < recommendedResults.count{
        if index != -1{
            if !hasSearched{
                if sections == 1{
                    let indexPath = IndexPath(row: index, section: sections)
                    tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                    if let cell = tableView.cellForRow(at: indexPath) as? SearchRecipesResultCell {
                        self.performSegue(
                            withIdentifier: "recipeSegue",
                            sender: cell)
                    }
                    
                }
                
                else if sections == 0{
                    self.moveOnRecipeDetail(index: index)
                }
            }
            
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "recipeSegue") {
            let recipeViewController = segue.destination as! RecipeDetailViewController
            
            //      Other method using UITableViewCell
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if hasSearched{
                    let searchResult = searchResults[indexPath!.row]
                    recipeViewController.searchResult = searchResult
                }
                else{
                    let trendingResult = trendingResults[indexPath!.row]
                    recipeViewController.trendingResult = trendingResult
                }
            }
        }
        else if(segue.identifier == "restrictionsSegue") {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! RestrictionsTableViewController
            destination.delegate = self
        }
    }
    
    // instantiate detail recipe for collection view cell
    func moveOnRecipeDetail(index: Int) {
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "RecipeDetailViewController") as? RecipeDetailViewController
        else{
            return
        }
        detailViewController.recommendedResult = recommendedResults[index]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    // MARK:- Helper Methods
    
    // URL object for API string
    func recipeURL(searchText: String) -> URL{
        // all the special characters(#,*,space) are escaped
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var restriction = [String]()
        for i in restrictions{
            if i.checked{
                restriction.append(i.text.lowercased())
            }
        }
        if !restriction.isEmpty {
            var urlString = String(
                format: globalVariables.url + "&q=%@", encodedText)
            var label = ""
            
            for i in restriction{
                label = i
                if i == restriction.first{
                    urlString += "&health=\(label)"
                }
                else{
                    urlString += "&\(label)"
                }
            }
            let url = URL(string: urlString)
            print(url!)
            return url!
        }
        else{
            let urlString = String(
                format: globalVariables.url + "&q=%@", encodedText)
            let url = URL(string: urlString)
            return url!
        }
    }
    
    // returns string object with the data received from the server from URL
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        }
        catch {
            print("Download Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchRecipesResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(
                ResultArray.self, from: data)
            
            return result.hits
            
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    func searchNow() {
        if !searchBar.text!.isEmpty
        {
            searchBar.resignFirstResponder() // dismiss keyboard
            dataTask?.cancel()
            isLoading = true
            tableView.reloadData()
            
            
            hasSearched = true
            searchResults = []
            
            // get URL object from API
            let url = recipeURL(searchText: searchBar.text!)
            print("URL: '\(url)'")
            if let data = performStoreRequest(with: url) {
                let results = parse(data: data)
                print("Got results: \(results)")
            }
            
            let session = URLSession.shared
            // returns the JSON data that is received from the server URL
            dataTask = session.dataTask(with: url, completionHandler: {
                data, response, error in
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                }
                else {
                    print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            })
            dataTask?.resume()
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error accessing the recipes." +
            " Please try again.",
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK:- Search Bar Delegate
extension SearchRecipesViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchNow()
    }
    
    
    // go back to trending page when search is cleared
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                self.hasSearched = false
                self.searchResultText = ""
                self.isLoading = false
                self.tableView.reloadData()
                self.viewDidLoad()
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultText = searchBar.text!
    }
    // extend search bar to status area
    func position(for bar: UIBarPositioning) -> UIBarPosition{
        return.topAttached
    }
}

// MARK:- Table View Delegate

extension SearchRecipesViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if !hasSearched && !isLoading && searchResultText.count == 0{
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        }
        else if !hasSearched && section == 0{
            return 1
        } else if !hasSearched && section == 1{
            return trendingResults.count
        } else if searchResults.count == 0{
            return 1
        } else{
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.loadingCell,
                for: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }
        else if hasSearched && searchResults.count == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.noRecipesFoundCell,for: indexPath)
        }
        else {
            if hasSearched{
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TableView.CellIdentifiers.searchRecipesResultCell,
                    for: indexPath) as! SearchRecipesResultCell
                
                let searchResult = searchResults[indexPath.row]
                cell.recipeNameLabel!.text = searchResult.recipe.label
                cell.recipeDescriptionLabel!.text = searchResult.recipe.source
                
                cell.configure(for: searchResult)
                return cell
            }
            else{
                if indexPath.section == 0 && !hasSearched{
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: "RecommendedTableViewCell", for: indexPath) as! RecommendedTableViewCell
                    cell.recommendedRecipe = recommendedResults
                    cell.index = indexPath.row
                    cell.didSelectRecipeClosure = { rIndex in
                        if let recipeIndex = rIndex{
                            self.moveOnRecipeDetail(index: recipeIndex)
                        }
                    }
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: TableView.CellIdentifiers.searchRecipesResultCell,
                        for: indexPath) as! SearchRecipesResultCell
                    
                    let trendingResult = trendingResults[indexPath.row]
                    cell.recipeNameLabel!.text = trendingResult.recipe.label
                    cell.recipeDescriptionLabel!.text = trendingResult.recipe.source
                    
                    cell.configure(for: trendingResult)
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !hasSearched {
            return 327 // fixed size
        }
        return UITableView.automaticDimension // automatic cell size
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "RecipesIndex")
        UserDefaults.standard.set(indexPath.section, forKey: "RecipesSection")
        
        if (!hasSearched && indexPath.section != 0 ) || hasSearched{
            let cell = tableView.cellForRow(at: indexPath)
            
            performSegue(withIdentifier: "recipeSegue", sender: cell)
            // deselect row with animation
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            if (hasSearched && searchResults.count == 0) || isLoading {
                return nil
            }
            else {
                return indexPath
            }
        }
    // Create a standard header that includes the returned text.
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        if hasSearched{
            return "\(searchResultText) Recipes"
        }
        else if !hasSearched && section == 0{
            return "Recommended Recipes"
        }
        return "Trending Recipes"
    }
    
}
