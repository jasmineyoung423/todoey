//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Jasmine Young on 6/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework



class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    let colours:[UIColor] =  [
        UIColor(hexString: "#F3C9DD")!,
        UIColor(hexString: "#F4D6D3")!,
        UIColor(hexString: "#F5F2D7")!,
        UIColor(hexString: "#C8F8E1")!,
        UIColor.flatPowderBlue(),
        UIColor(hexString: "#D6C9F2")!,
        UIColor.flatWhite()
    ]
    
    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    // MARK: - SwipeTableViewCellDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {return nil}
        
        let swipeAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
        }
        swipeAction.image = UIImage(named: "delete-icon")
        
        return [swipeAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath:IndexPath) {
        // update data model
    }
}
