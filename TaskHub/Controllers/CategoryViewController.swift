//
//  CategoryListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 20.09.2023.
//

import UIKit
import CoreData

final class CategoryViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
    }
    
    // MARK: - Private Actions
    @objc private func addBarButtonDidTapped() {
        let alert = UIAlertController(
            title: "Add New Category",
            message: "",
            preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { alertTextField in
            textField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add category", style: .default) { alert in
            if let text = textField.text, textField.text != nil {
            }
        }
        
        alert.addAction(addAction)
        present(alert, animated: true)
        
    }

    // MARK: - Private Methods
    
    // MARK: - Data Manipulation Methods
   
}

// MARK: - UITableViewDataSource
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
   
//        content.text = category.name
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController {
    
}

// MARK - NavigationBar settings
extension CategoryViewController {
    private func setupNavigationBar() {
        title = "TaskHub"
        
        let addBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addBarButtonDidTapped)
        )
        
        addBarButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = addBarButton
        
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
    }
}
