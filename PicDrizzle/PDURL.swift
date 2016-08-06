//
//  PDURL.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 7/17/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation

struct PDURL {
    
    static let BASE_URL  = "https://api.unsplash.com/photos/?client_id="
    
    static let CLIENT_ID = "547fb6b21330ac025928c3261b1b3517239c15fa968608d1b26fdfd3d383b1b4"
    var URL:String {
         return PDURL.BASE_URL+PDURL.CLIENT_ID
    }


}
