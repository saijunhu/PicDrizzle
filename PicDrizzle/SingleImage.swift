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
    var thumb = NSURL()
    var small = NSURL()
    var regular = NSURL()
    var full = NSURL()
    var raw = NSURL()
    
    init(id: String, thumb: NSURL, small: NSURL, regular: NSURL, full: NSURL, raw: NSURL) {
        self.id = id
        self.thumb = thumb
        self.small = small
        self.regular = regular
        self.full = full
        self.raw = raw
    }
}
