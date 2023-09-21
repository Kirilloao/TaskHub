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
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //создаем массив Сategory
    private var categoryArray = [Category]()

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        // регистрируем ячейку
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        
        // загружаем обекты из СoreData в массив categoryArray
        loadItems()
    }
    
    // MARK: - Private Actions
    @objc private func addBarButtonDidTapped() {
       showAlert()
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
                // создаем обьект Category в контексте CoreData
                let category = Category(context: self.context)
                //добавяем текст из textField в атрибут category
                category.name = text
                // добавляем обьект в массив
                self.categoryArray.append(category)
                
                //вставляем новый обьект в список tableView
                self.tableView.insertRows(
                    at: [IndexPath(row: self.categoryArray.count - 1, section: 0)],
                    with: .automatic
                )
                
                // сохраняем изменения в СoreData
                self.saveItems()
            }
        }
        
        // добавляем кнопку add в alertController
        alert.addAction(addAction)
        
        //отображаем alertController
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = category.name

        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // снимаем выделение ячейки после нажатия
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Model Manupulation Methods
extension CategoryViewController {
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
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

