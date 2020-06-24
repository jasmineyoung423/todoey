//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var items: Results<TodoItem>?
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour {
            if let colour = UIColor(hexString: colourHex) {
                guard let navBar = navigationController?.navigationBar else {fatalError("Nav bar not loaded")}
                navBar.backgroundColor = colour
                navBar.subviews[0].backgroundColor = colour
                navBar.barTintColor = colour
                let contrastColour = ContrastColorOf(colour, returnFlat: true)
                navBar.tintColor = contrastColour
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColour]
                searchBar.barTintColor = colour
                searchBar.searchTextField.backgroundColor = contrastColour
                searchBar.searchTextField.textColor = colour
                searchBar.searchTextField.tintColor = colour
            }
            navigationController?.title = selectedCategory!.name
        }
    }
    
    // MARK: - CRUD
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Todoey Item", style: .default) { (action) in
            if let text = textField.text {
                if let cat = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let item = TodoItem()
                            item.title = text
                            item.done = false
                            cat.items.append(item)
                        }
                    }
                    catch {
                        print("Save Items: \(error.localizedDescription)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            }
            catch {
                print("Could not delete item: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(items!.count))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ?  .checkmark :  .none
            
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = items?[indexPath.row]
        {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Update Done: \(error.localizedDescription)")
            }
        }
        tableView.reloadData()
        
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            items = items?.filter("title CONTAINS[cd] %@", text)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            if let text = searchBar.text {
                loadItems()
                items = items?.filter("title CONTAINS[cd] %@", text)
                tableView.reloadData()
            }
        }
    }
}
