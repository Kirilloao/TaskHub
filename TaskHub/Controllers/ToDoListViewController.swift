//
//  ToDoListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit
import SnapKit

final class ToDoListViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        content.text = itemArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NavigationBar
extension ToDoListViewController {
    private func setupNavigationBar() {
        title = "TaskHub"
        
        let navBarAppearance = UINavigationBarAppearance()
        
        //устанавливаем цвет для navigationBar
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        // меняем цвет для текста
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // меняем цвет в статичном положении и в скролинге
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonDidTapped)
        )
        addButton.tintColor = .white
    
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonDidTapped() {

        var textField = UITextField()

        let alert = UIAlertController(
            title: "Add New Task",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            if let text = textField.text, textField.text != nil {
                self.itemArray.append(text)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.insertRows(
                    at: [IndexPath(row: self.itemArray.count - 1, section: 0)],
                    with: .automatic
                )
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

