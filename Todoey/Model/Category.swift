//
//  Category.swift
//  Todoey
//
//  Created by Jasmine Young on 6/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<TodoItem>()
}
