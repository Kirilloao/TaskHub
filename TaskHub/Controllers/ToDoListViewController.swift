//
//  ToDoListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit
import SnapKit
import CoreData

final class ToDoListViewController: UITableViewController {
    
    // MARK: - Private UI Properties
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .black
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // MARK: - Private Properties
    private var itemArray = [Item]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        
        loadItems()
    }
    
    // MARK: - Private Actions
    @objc private func addButtonDidTapped() {
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add New Task",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            if let text = textField.text, textField.text != nil {
                
                
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.isDone = false
                
                self.itemArray.append(newItem)
                
                // сохраняем данные
                self.tableView.insertRows(
                    at: [IndexPath(row: self.itemArray.count - 1, section: 0)],
                    with: .automatic
                )
                self.saveItems()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - Model Manupulation Methods
extension ToDoListViewController {
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let item = itemArray[indexPath.row]
        
        content.text = item.title
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NavigationBar
extension ToDoListViewController {
    private func setupNavigationBar() {
        title = "Items"
        
//        let navBarAppearance = UINavigationBarAppearance()
//        
//        //устанавливаем цвет для navigationBar
//        navBarAppearance.backgroundColor = UIColor(
//            red: 21/255,
//            green: 101/255,
//            blue: 192/255,
//            alpha: 194/255
//        )
//        
//        // меняем цвет для текста
//        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        
//        // меняем цвет в статичном положении и в скролинге
//        navigationController?.navigationBar.standardAppearance = navBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonDidTapped)
        )
        addButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = addButton
        
        // устанавливаем searchBar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
