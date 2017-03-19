//
//  SingleImage.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 8/7/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm

class SingleImage: Object {
    
    dynamic var id:String = ""
    dynamic var regular = ""
    dynamic var full = ""
    dynamic var raw = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
