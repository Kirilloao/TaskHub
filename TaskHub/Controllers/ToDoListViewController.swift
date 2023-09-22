//
//  ToDoListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit
import SnapKit
import RealmSwift

final class ToDoListViewController: UITableViewController {
    
    // MARK: - Private Methods
    private let realm = try! Realm()
    
    // MARK: - Public Properties
    /* Вычисляемое свойство, didSet выполняется каждый раз когда значение свойства
     меняется. LoadItem() будет загружать только те обьекты которые отоносятся
     к этой категории.
     */
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - Private Properties
    private var items: Results<Item>?
    
    // MARK: - Private UI Properties
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .black
        searchController.searchBar.backgroundColor = .white
        //        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Private Actions
    @objc private func addButtonDidTapped() {
        showAlert()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func showAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add New Task",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            // проверяется значение из textField, не является ли он пустым
            if let text = textField.text, textField.text != nil {
                // проверяется свойство selectedCategory на nil
                if let currentCategory = self.selectedCategory {
                    /*
                     Cоздается новый объект item, вносятся изменения в его атрибуты,
                     и созданный объект добавляется к выбранной категории в ее массив
                     items.(У каждой категории есть массив items)
                     После чего все сохраняется в базу данных.
                     */
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
                self.tableView.reloadData()
                //                self.tableView.insertRows(at: [IndexPath(item: items.count - 1, section: 0)], with: .automatic)
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - Model Manupulation Methods
extension ToDoListViewController {
    private func loadItems() {
        /*
         В данном методе мы пытаемся присвоить массиву items результат сортировки
         объектов item.
         
         Метод sorted(byKeyPath:ascending:)  применяет сортировку к коллекции items.
         Аргументы метода определяют, как именно будет производиться сортировка.
         
         byKeyPath: "title": Это путь к ключевому свойству, по которому будет
         производиться сортировка. В данном случае, сортировка будет осуществляться
         по свойству title в каждом объекте Item.
         
         ascending: true: Этот аргумент указывает, что сортировка будет в
         возрастающем порядке (от A до Z).
         
         После выполнения этой строки кода, переменная items будет содержать
         отсортированный массив объектов Item из коллекции items, связанной с
         selectedCategory. Теперь items будет представлять собой массив объектов
         Item, упорядоченных по алфавиту и приведенных к порядку "от A до Z" на
         основе свойства title каждого объекта.
         */
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        
        var content = cell.defaultContentConfiguration()
        
        if let item = items?[indexPath.row] {
            content.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            content.text = "No Items Added"
        }
        
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //        items[indexPath.row].isDone = !items[indexPath.row].isDone
        //        dataManager.saveContext()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NavigationBar
extension ToDoListViewController {
    private func setupNavigationBar() {
        title = "Items"
        
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
//
//// MARK: - UISearchBarDelegate
//extension ToDoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        // создаем запрос для получения объектов типо item из CoreData
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        /*
//         Создаем предикат который создаем условие для фильтрации данных.
//         Мы ищем объекты у которых атрибут title содержит текст введенный
//         в searchBar.
//         */
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        /*
//         Устанавливаем предикат для запроса. Это означает что запрос будет
//         фильтровать объекты на основе условия в предикате.
//         */
//        request.predicate = predicate
//
//        /*
//         Устанавливаем сортировку для запроса. Указываем что результаты запроса
//         должны быть отсортированы по атрибуту title в возрастающем порядке.
//         */
//        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//
//        /*
//         загружаем элементы из СoreData с учетом заданого запроса и предиката.
//         */
//        loadItems(with: request, predicate: predicate)
//
//        // обновляем таблицу
//        tableView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            tableView.reloadData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
