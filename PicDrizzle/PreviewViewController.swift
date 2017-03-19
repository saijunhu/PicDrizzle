//
//  PreviewViewController.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 7/17/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import Koloda
import SnapKit
import SwiftyJSON
import Kingfisher
import PKHUD
import Moya
import Alamofire
import SwiftyUserDefaults
import RealmSwift

//TODO: fix the bug, when the number of user likes less than 10, the array index passed
class PreviewViewController: BaseViewController {
    
    var page: Int = 1

    lazy var kolodaView: KolodaView = {
        let view = KolodaView()
        view.backgroundColor = nil
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var glass: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView(effect: effect)
        view.frame.size = CGSize(width: WIDTH, height: HEIGHT)
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    lazy var favoriteBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "ic_favorite"), for: .normal)
        btn.isEnabled = true
        btn.backgroundColor = nil
        btn.addTarget(self, action: #selector(switchFavoriteMode(sender:)), for: .touchUpInside)
        return btn
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //        self.navigationController?.navigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.addSubview(bgView)
        self.bgView.addSubview(glass)
        self.view.addSubview(kolodaView)
        self.view.addSubview(self.favoriteBtn)

        Defaults[.username] = "crazyatlantis"
        ImageManager.refresh(1){ ()-> Void in
            self.kolodaView.reloadData()
        }

        handleLayout()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        clearResourcesArray()
        self.page = 1

    }
    
    
}

// MARK:  Handle something
extension PreviewViewController {

    func handleLayout(){
        
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        
        glass.snp.makeConstraints { make in
            make.edges.equalTo(self.bgView).inset(UIEdgeInsets.zero)
        }
        
        //        dropView.snp.makeConstraints { make in
        //            make.edges.equalTo(self.bgView).inset(UIEdgeInsets.zero)
        //        }
        kolodaView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(80, 30, 80, 30))
        }

        favoriteBtn.snp.makeConstraints{ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
        }

    }

    func switchFavoriteMode(sender: UIButton){
        present(FavoriteViewController(), animated: true, completion: nil)
    }

    
}


