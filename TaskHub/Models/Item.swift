//
//  Item.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 21.09.2023.
//

import Foundation
import RealmSwift

/*
 В контексте RealmSwift, класс Object служит базовым классом для всех объектов,
 которые могут быть сохранены в базе данных Realm.
 */
class Item: Object {
    /*
     Модификатор dynamic связан с Objective-C. Он позволяет Realm
     отслеживать изменения этого свойства и обеспечивать синхронизацию
     с базой данных.
     */
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    
    /*
     LinkingObjects: Это тип, предоставляемый библиотекой RealmSwift, который
     используется для создания обратных связей между объектами в базе данных Realm.
     Он позволяет вам определить, какие объекты "ссылаются" на текущий объект.
     
     fromType: Category.self: Здесь указывается тип объекта, который ссылается на
     текущий объект Item. В данном случае, это объекты типа Category.
     
     property: "items": Это имя свойства в объекте Category, которое устанавливает
     связь с объектами Item. В других словах, parentCategory указывает на связанные
     объекты Category, где items - это свойство в объекте Category, которое создает
     эту обратную связь.
     */
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
