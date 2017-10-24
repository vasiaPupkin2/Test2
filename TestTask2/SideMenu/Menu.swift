//
//  Menu.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import Foundation

class Menu: NSObject {
    let titleName: MenuNames
    let imageName: String
    let cellId: String
    
    init(titleName: MenuNames, imageName: String, cellId: String) {
        self.titleName = titleName
        self.imageName = imageName
        self.cellId = cellId
    }
}

enum MenuNames: String {
    case photos = "Photos"
    case map = "Map"
}
