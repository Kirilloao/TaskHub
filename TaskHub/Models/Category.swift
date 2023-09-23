//
//  Category.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 21.09.2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    /*
     Создаем свойство которое будет хранит цвет в формате hex, при загрузке
     приложения ячейка с этий свойство будет окрашиваться в сохраненный цвет.
     */
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
