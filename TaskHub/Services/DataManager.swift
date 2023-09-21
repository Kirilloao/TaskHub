//
//  DataManager.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 21.09.2023.
//

import Foundation
import CoreData

final class DataManager {
    /*
     Здесь создается статическая константа shared, которая представляет собой
     единственный экземпляр (синглтон) класса DataManager. Этот синглтон позволяет
     обеспечить глобальный доступ к экземпляру DataManager из любой точки вашего приложения.
     */
    static let shared = DataManager()
    
    /*
     Здесь создается и настраивается экземпляр NSPersistentContainer, который
     представляет собой контейнер CoreData. Он используется для управления
     CoreData-хранилищем данных, включая создание и настройку базы данных CoreData.
     Этот контейнер загружает настройки из файла данных с именем "DataModel".
     Если при загрузке происходит ошибка, приложение завершает работу с выводом
     информации об ошибке.
     */
    private let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /*
     Создается экземпляр NSManagedObjectContext, который представляет собой
     контекст для выполнения операций с данными в CoreData. Этот контекст будет
     использоваться для создания, чтения, обновления и удаления объектов CoreData.
     */
    private let viewContext: NSManagedObjectContext
    
    /*
     Приватный инициализатор класса DataManager. Это означает, что класс DataManager
     не может быть создан напрямую извне, и его единственный экземпляр доступен
     через статическую константу shared.
     */
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    
    // CREATE
    func create<T: NSManagedObject>(objectType: T.Type, with name: String, parentCategory: Category? = nil, completion: (T) -> Void) {
        let object = T(context: viewContext)
        
        if let category = object as? Category {
            category.name = name
        } else if let item = object as? Item {
            item.title = name
            item.isDone = false
            item.parentCategory = parentCategory
        }
        
        completion(object)
        saveContext()
    }
    
    // READ
    func fetchItems<T>(with request: NSFetchRequest<T>, completion: (Result<[T], Error>) -> Void) {
        do {
            let categories  = try viewContext.fetch(request)
            completion(.success(categories))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /*
     Метод saveContext() предназначен для сохранения всех изменений, сделанных
     в контексте viewContext, в базе данных CoreData. Если есть несохраненные
     изменения в контексте, они будут сохранены. Если произойдет ошибка
     при сохранении, будет выведено сообщение об ошибке.
     */
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
