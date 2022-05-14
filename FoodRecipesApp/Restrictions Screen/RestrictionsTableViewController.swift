//
//  RestrictionsTableViewController.swift
//  FoodRecipesApp
//
//  Created by Ajdin on 12. 5. 2022..
//

import UIKit

protocol RestrictionsControllerDelegate: AnyObject {
  func restrictionsControllerDidCancel(
    _ controller: RestrictionsTableViewController)
  func restrictionsController(
    _ controller: RestrictionsTableViewController,
    didFinishAdding item: [ChecklistItem]
  )
}

class RestrictionsTableViewController: UITableViewController {
    var delegate: RestrictionsControllerDelegate?

    @IBAction func cancelButton() {
        delegate?.restrictionsControllerDidCancel(self)
    }
    @IBAction func doneButton() {
        let itemArray = items
        delegate?.restrictionsController(self, didFinishAdding: itemArray)
        
    }

    var items = [ChecklistItem]()
    
    // define health restriction labels
    let healthLabels = ["Gluten-Free",
                        "Wheat-Free",
                        "Peanut-Free",
                        "Tree-Nut-Free",
                        "Soy-Free",
                        "Fish-Free",
                        "Shellfish-Free",
                        "Pork-Free",
                        "Red-Meat-Free",
                        "Crustacean-Free",
                        "Celery-Free",
                        "Sesame-Free",
                        "Lupine-Free",
                        "Mollusk-Free"]
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in healthLabels{
            let rLabels = ChecklistItem()
            rLabels.text = i
            items.append(rLabels)
        }
        loadChecklistItems()
    }
    func configureCheckmark(
      for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        if item.checked {
            cell.accessoryType = .checkmark
          } else {
            cell.accessoryType = .none
      }
    }
    func configureText(
        for cell: UITableViewCell,
          with item: ChecklistItem
        ) {
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.text
    }
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      return paths[0]
    }

    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("FoodRecipes.plist")
    }
    // save which restriction items the user picks
    func saveChecklistItems() {
      let encoder = PropertyListEncoder()
      do {
        let data = try encoder.encode(items)
        try data.write(
          to: dataFilePath(),
          options: Data.WritingOptions.atomic)
      } catch {
        print("Error encoding item array: \(error.localizedDescription)")
      }
    }
    // load users' restriction items
    func loadChecklistItems() {
      let path = dataFilePath()
      if let data = try? Data(contentsOf: path) {
        let decoder = PropertyListDecoder()
        do {
            items = try decoder.decode(
                [ChecklistItem].self,
            from: data)
        } catch {
          print("Error decoding item array: \(error.localizedDescription)")
        }
      }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestrictionsCell", for: indexPath) as! RestrictionsTableViewCell
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }

    // toggle the checkmark
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
        if let cell = tableView.cellForRow(at: indexPath) {
        let item = items[indexPath.row]
          item.checked.toggle()
          configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
}
