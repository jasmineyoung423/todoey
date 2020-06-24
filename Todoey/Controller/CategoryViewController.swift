//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jasmine Young on 6/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

// MARK: - ViewController
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colour = UIColor(hexString: "FFB6B6") {
            guard let navBar = navigationController?.navigationBar else {fatalError("Did not load nav bar")}
            navBar.backgroundColor = colour
            navBar.subviews[0].backgroundColor = colour
            navBar.barTintColor = colour
            let contrastColour = ContrastColorOf(colour, returnFlat: true)
            navBar.tintColor = contrastColour
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColour]
            view.backgroundColor = colour // the whitespace below the categories
        }
    }
    
    // MARK: - CRUD
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Todoey Category", style: .default) { (action) in
            if let text = textField.text {
                let category = Category()
                category.name = text
                if let colour = self.colours.randomElement()?.hexValue() {
                    category.colour = colour
                }
                self.saveCategory(category)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Save Categories: \(error.localizedDescription)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            }
            catch {
                print("Could not delete category: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? colours[0].hexValue())
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }
}
