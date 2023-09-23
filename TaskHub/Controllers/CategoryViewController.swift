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
        addBarButton()
        setupTableView()
        
        // загружаем обекты из СoreData в массив categoryArray
        loadCategories()
    }
    
    // изменяем цвет navigationBar в момент когда собитаертся появится
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupnNavigationBar()
    }
    
    // MARK: - Private Actions
    @objc private func addBarButtonDidTapped() {
        showAlert()
    }
    
    // MARK: - Model Manupulation Methods
    // сохраняем данные
    private func save(category: Category) {
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
        
        // извлекаем опциональное значение из массива categories по индексу
        if let category = categories?[indexPath.row] {
            
            // устанавливаем название категории в ячейки
            content.text = category.name
            
            // извлекаем опциональное значение из с модели категория и ее свойва цвет
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            // устанавливаем задний фон цветом из категории
            cell.backgroundColor = categoryColour
            
            // устанавливаем цвет текста контрастным (зависит от цвета в категории)
            content.textProperties.color = ContrastColorOf(categoryColour, returnFlat: true)
        }
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

// MARK: - NavigationBar settings
extension CategoryViewController {
    private func setupnNavigationBar() {
        title = "TaskHub"
        
        let navBarAppearance = UINavigationBarAppearance()
        
        guard
            let navBar = navigationController?.navigationBar
        else {
            fatalError("Navigation controller does not exist.")
        }
        
        // Устанавливаем цвет для navigationBar
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBar.prefersLargeTitles = true
        
        // Меняем цвет для текста
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Меняем цвет в статичном положении и в скроллинге
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func addBarButton() {
        let addBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addBarButtonDidTapped)
        )
        
        addBarButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = addBarButton
    }
}
