//
//  ImageResources.swift
//  PicDrizzle
//
//  Created by plusub on 19/03/2017.
//  Copyright © 2017 胡胡赛军. All rights reserved.
//

import Foundation
import UIKit
import Koloda
import SnapKit
import SwiftyJSON
import Kingfisher
import PKHUD
import Moya
import Alamofire
import SwiftyUserDefaults

class ImageManager: NSObject {

    static var ids = [String]()
    static var thumbs = [URL]()
    static var smalls = [URL]()
    static var regulars = [URL]()
    static var fulls = [URL]()
    static var raws = [URL]()

    static func get(_ page: Int = 1,callback:@escaping ()->(Void)){

        PDNetwork.Request(target: .getImageResources(page: page)) { (jsonData) in
            guard let Array = jsonData.array else {
                return
            }
            for picInfo in Array{
                ids.append(picInfo["id"].string ?? "")
                self.thumbs.append(NSURL(string: picInfo["urls"]["thumb"].string!)! as URL)
                self.smalls.append(NSURL(string: picInfo["urls"]["small"].string!)! as URL)
                self.regulars.append(NSURL(string: picInfo["urls"]["regular"].string!)! as URL)
                self.fulls.append(NSURL(string: picInfo["urls"]["full"].string!)! as URL)
                self.raws.append(NSURL(string: picInfo["urls"]["raw"].string!)! as URL)
            }
            print("ImageResources get data success")
            callback()

        }
    }

    static func refresh(_ page: Int = 1, callback: @escaping ()->(Void)){
        clear()
        get(page,callback: callback)
    }

    static func clear(){
        self.ids = [String]()
        self.thumbs = [URL]()
        self.smalls = [URL]()
        self.regulars = [URL]()
        self.fulls = [URL]()
        self.raws = [URL]()
    }



}
