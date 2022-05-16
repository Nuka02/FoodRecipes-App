import Foundation

struct TrendingRecipes: Codable{
    var from: Int
    var to: Int
    var count: Int
    var hits = [TrendingResults]()
}

struct TrendingResults: Codable {
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

extension TrendingRecipes {
    static func trendingRecipies() -> [TrendingResults]{
        guard
            let url = URL(string: globalVariables.url + "&q=Trending"),
            let data = try? Data(contentsOf: url)
        else {
            return []
        }
        
        do {
          let decoder = JSONDecoder()
            let result = try decoder.decode(TrendingRecipes.self, from: data)
            return result.hits
        }
        catch {
          return []
        }
    }
}
