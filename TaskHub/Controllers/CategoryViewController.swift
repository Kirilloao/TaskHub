//
//  CategoryListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 20.09.2023.
//

import UIKit
import RealmSwift

final class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // MARK: - Private Properties
    /*
     В данном случае, Results - это тип, предоставляемый Realm, который представляет
     собой коллекцию объектов определенной модели данных. Category здесь указывает
     на тип объектов, которые будут храниться в этой коллекции.
     */
    private var categories: Results<Category>?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
        // загружаем обекты из СoreData в массив categoryArray
        loadCategories()
    }
    
    // MARK: - Private Actions
    @objc private func addBarButtonDidTapped() {
        showAlert()
    }
    
    // MARK: - DataManager Methods
    //    private func save(text: String) {
    //        self.dataManager.create(objectType: Category.self, with: text) { category in
    //            self.categories.append(category)
    //            self.tableView.insertRows(
    //                at: [IndexPath(row: self.categories.count - 1, section: 0)],
    //                with: .automatic
    //            )
    //        }
    //    }
    
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
                let newCategory = Category()
                newCategory.name = text
                self.save(category: newCategory)
                
                self.tableView.insertRows(
                    at: [IndexPath(row: (self.categories?.count ?? 1) - 1, section: 0)],
                    with: .automatic
                )
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
        categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "categoryCell",
            for: indexPath
        )
        
        let category = categories?[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = category?.name ?? "No categories added yet"
        
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
        toDoListVC.selectedCategory = categories?[indexPath.row]
        
        // выполняем переход по навигации
        navigationController?.pushViewController(toDoListVC, animated: true)
    }
}

// MARK: - Model Manupulation Methods
extension CategoryViewController {
    func save(category: Category) {
        do {
            /*
             realm.write выполняет операцию сохранения объекта category в базе
             данных Realm.
             */
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    private func loadCategories() {
        /*
         Это вызов метода objects(_:) для Realm с указанием типа Category.
         Этот метод возвращает коллекцию объектов типа Category из базы данных Realm.
         То есть, он извлекает все записи из таблицы, соответствующей модели Category.
         */
        categories = realm.objects(Category.self)
    }
}

// MARK: - NavigationBar settings
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

