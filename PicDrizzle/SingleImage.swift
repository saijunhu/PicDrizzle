//
//  SingleImage.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 8/7/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation
import UIKit

class SingleImage: NSObject {
    
    var id:String = ""
    var thumb = URL(string: "")
    var small = URL(string: "")
    var regular = URL(string: "")
    var full = URL(string: "")
    var raw = URL(string: "")
    
    init(id: String, thumb: URL, small: URL, regular: URL, full: URL, raw: URL) {
        self.id = id
        self.thumb = thumb
        self.small = small
        self.regular = regular
        self.full = full
        self.raw = raw
    }
}
