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
    let items = List<Item>()
}
