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
    // создаем обьект контекста для работы с базой данных
    private let dataManager = DataManager.shared
    
    //создаем массив Сategory
    private var categories = [Category]()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
        // загружаем обекты из СoreData в массив categoryArray
        loadItems()
    }
    
    // MARK: - Private Actions
    @objc private func addBarButtonDidTapped() {
        showAlert()
    }
    
    // MARK: - DataManager Methods
    private func save(text: String) {
        self.dataManager.create(objectType: Category.self, with: text) { category in
            self.categories.append(category)
            self.tableView.insertRows(
                at: [IndexPath(row: self.categories.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    
    // MARK: - Private Methods
    private func showAlert() {
        //создаем AlertController
        let alert = UIAlertController(
            title: "Add New Category",
            message: "",
            preferredStyle: .alert)
        
        var textField = UITextField()
        
        // добавляем textField в AlertController
        alert.addTextField { alertTextField in
            textField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add category", style: .default) { _ in
            //извлекаем текст из textField и проверям не пустой ли он
            if let text = textField.text, textField.text != nil {
                self.save(text: text)
            }
        }
        alert.addAction(addAction)
        
        //отображаем alertController
        present(alert, animated: true)
    }
    
    private func setupTableView() {
        // регистрируем ячейку
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "categoryCell"
        )
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "categoryCell",
            for: indexPath
        )
        
        let category = categories[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = category.name
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController {
    //отрабатываем когда мы нажимаем на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // снимаем выделение ячейки после нажатия
        tableView.deselectRow(at: indexPath, animated: true)
        
        // создаем экземпляр класса на который будем делать переход
        let toDoListVC = ToDoListViewController()
        
        // передаем выбранную категорию в свойство которое находится в toDoListVC
        toDoListVC.selectedCategory = categories[indexPath.row]
        
        // выполняем переход по навигации
        navigationController?.pushViewController(toDoListVC, animated: true)
    }
}

// MARK: - Model Manupulation Methods
extension CategoryViewController {
    private func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        dataManager.fetchItems(with: request) { (result: Result<[Category], Error>) in
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                print(error)
            }
        }
    }
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
    }
}

