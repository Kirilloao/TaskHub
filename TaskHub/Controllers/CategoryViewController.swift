//
//  CategoryListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 20.09.2023.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

final class CategoryViewController: SwiftTableViewController {
    
    // MARK: - Private Properties
    /*
     В данном случае, Results - это тип, предоставляемый Realm, который представляет
     собой коллекцию объектов определенной модели данных. Category здесь указывает
     на тип объектов, которые будут храниться в этой коллекции.
     */
    private var categories: Results<Category>?
    private let realm = try! Realm()
    
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
    
    // MARK: - Model Manupulation Methods
    // сохраняем данные
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
    
    // скачиваем данные
    private func loadCategories() {
        /*
         Это вызов метода objects(_:) для Realm с указанием типа Category.
         Этот метод возвращает коллекцию объектов типа Category из базы данных Realm.
         То есть, он извлекает все записи из таблицы, соответствующей модели Category.
         */
        categories = realm.objects(Category.self)
    }
    
    // удаляем данные (вызываем метод которые создали из класса SwiftTableViewController
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
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
                let newCategory = Category()
                newCategory.name = text
                /*
                 Сначала мы созадем свойство в модели category в которое будем
                 сохраняем наш цвет.
                 Cохраняем рандомный цвет в формате hex.
                 */
                newCategory.colour = UIColor.randomFlat().hexValue()
                
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
            SwipeTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
        tableView.separatorStyle = .none
        
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        let category = categories?[indexPath.row]
        
        content.text = category?.name ?? "No categories added yet"
        cell.backgroundColor = UIColor(hexString: category?.colour ?? "1D9BF6")
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
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

//// MARK: - SwipeTableViewCellDelegate
//// используем фреймворк SwiftCellKit
//extension CategoryViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            if let category = self.categories?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(category)
//                    }
//                } catch {
//                    print("Error deleting category, \(error)")
//                }
////                tableView.reloadData()
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
////        options.transitionStyle = .border
//        return options
//    }
//}

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
