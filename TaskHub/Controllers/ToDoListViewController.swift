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
    private var itemArray = [Item]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Private UI Properties
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .black
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.delegate = self
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
                newItem.parentCategory = self.selectedCategory
                
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
    
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        /*
         Предикат будет использоваться для выбора всех элементов (Item) из Core Data,
         у которых родительская категория (parentCategory) имеет атрибут name,
         который соответствует имени выбранной категории (selectedCategory).
         Это позволяет фильтровать элементы в соответствии с выбранной категорией.
         */
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        /*
         Если пользователь ввел текст для поиска, то predicate будет непустым,
         и код внутри блока if будет выполнен.
         
         Созданный составной предикат будет выполняться по "И" (AND),
         то есть объекты должны удовлетворять обоим предикатам, чтобы быть
         включенными в результаты запроса.
         
         Если additionalPredicate отсутствует (то есть пользователь не выполнил
         поиск или не ввел текст для поиска), то в блоке else будет установлен
         только предикат categoryPredicate, который фильтрует объекты по категории
         без каких-либо дополнительных условий.
         
         */
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        

        // загружаем данные из СoreData в массив
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
        
        // создаем запрос для получения объектов типо item из CoreData
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        /*
         Создаем предикат который создаем условие для фильтрации данных.
         Мы ищем объекты у которых атрибут title содержит текст введенный
         в searchBar.
         */
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        /*
         Устанавливаем предикат для запроса. Это означает что запрос будет
         фильтровать объекты на основе условия в предикате.
         */
        request.predicate = predicate
        
        /*
         Устанавливаем сортировку для запроса. Указываем что результаты запроса
         должны быть отсортированы по атрибуту title в возрастающем порядке.
         */
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        /*
         загружаем элементы из СoreData с учетом заданого запроса и предиката.
         */
        loadItems(with: request, predicate: predicate)
        
        // обновляем таблицу
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
