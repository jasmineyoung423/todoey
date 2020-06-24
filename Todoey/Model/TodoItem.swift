//
//  TodoItem.swift
//  Todoey
//
//  Created by Jasmine Young on 6/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    let category = LinkingObjects(fromType: Category.self, property: "items")
}
