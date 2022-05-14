import Foundation

struct ResultArray: Codable {
    var from: Int
    var to: Int
    var count: Int
    var hits = [SearchRecipesResult]()
}

struct SearchRecipesResult: Codable {
    var recipe: Recipe
    
    
    struct Recipe: Codable
    {
        var label: String?
        var source: String?
        var image: String?
        var url: String?
        var yield: Double?
        var dietLabels = [String?]()
        var healthLabels = [String?]()
        var ingredientLines = [String?]()
        var calories: Double?
        var totalTime: Double?
        var cuisineType = [String?]()
        var mealType = [String?]()
        var dishType = [String?]()
    }
}

