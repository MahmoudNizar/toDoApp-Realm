//
//  Items.swift
//  toDoApp
//
//  Created by Mahmoud on 1/18/22.
//

import Foundation
import RealmSwift
class Items: Object {
    @objc dynamic var done : Bool     = false
    @objc dynamic var task : String   = "Save The World"
}
