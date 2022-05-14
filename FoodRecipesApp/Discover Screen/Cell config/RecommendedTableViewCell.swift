//
//  RecommendedTableViewCell.swift
//  FoodRecipesApp
//
//  Created by Ajdin on 11. 5. 2022..
//

import UIKit

typealias DidSelectRecipeClosure = ((_ index: Int?) -> Void)

class RecommendedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var index: Int?
    var didSelectRecipeClosure: DidSelectRecipeClosure?
    
    var recommendedRecipe: [RecommendationResults]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension RecommendedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedRecipe!.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
        let result = recommendedRecipe![indexPath.row]
        cell.configure(for: result)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 193, height: 304)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(
            indexPath.row,
            forKey: "RecipesIndex")
        UserDefaults.standard.set(
            indexPath.section,
            forKey: "RecipesSection")
        didSelectRecipeClosure?(indexPath.row)
    }
}
