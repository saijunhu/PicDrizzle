//
//  PDNetwork.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 7/17/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PKHUD
import Moya

let header:Dictionary = ["Authorization": "Bearer e3cee9eb2e20e4acb3b15214f52eee60f29831880e11c4bad6aa98e5dab55289"]

class PDNetwork: NSObject {
    
    static func Request(target: PDService, fetchData: @escaping (JSON) -> Void) {
        
        provider.request(target){ result in
            switch result {
            case .success(let response):
                
                let json = JSON(data: response.data)
//                 debugPrint(json)
                if json["errors"] != nil {
                    showError(description: "request refuesd")
                    debugPrint("request refused")
                }else{
                    debugPrint("request success")
//                    debugPrint(json)
                    return fetchData(json)
                }
                print("network success")
                
            case .failure(let error):
                showError(description: error.localizedDescription)
                print("network failed")
                
            }
        }
    }
    
    static func showError(description: String){
        

        HUD.flash(.labeledError(title: "Error", subtitle: "description"), delay: 0.1) { _ in
            
        }
    }
    //
//    
//    static func testRequest(page: Int, fetchData: JSON -> Void){
//        
//        Alamofire.request(.GET, "https://api.unsplash.com/photos?page=\(page)", headers: header).validate().responseJSON{ response in
//            switch response.result {
//            case .Success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    debugPrint(json)
//                    if json["errors"].string != nil{
//                        showError("request refuesd")
//                        debugPrint("request refused")
//                    }else{
//                        debugPrint("request success")
//                        return fetchData(json)
//                    }
//                    print("network success")
//                }
//            case .Failure(let error):
//                showError(error.description)
//                print("network failed")
//                
//            }
//        }
//        
//    }

}
