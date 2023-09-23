//
//  SwiftTableViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 22.09.2023.
//

import UIKit
import SwipeCellKit

class SwiftTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    // TableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // используем фреймворк SwiftCellKit
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SwipeTableViewCell
        
        // используем фреймворк SwiftCellKit
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
            //            if let category = self.categories?[indexPath.row] {
            //                do {
            //                    try self.realm.write {
            //                        self.realm.delete(category)
            //                    }
            //                } catch {
            //                    print("Error deleting category, \(error)")
            //                }
            //            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //        options.transitionStyle = .border
        return options
    }
    
    // update data model
    func updateModel(at indexPath: IndexPath) {
        
    }
}
