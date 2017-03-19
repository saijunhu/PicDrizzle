//
//  FavoriteViewController.swift
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
import RealmSwift

//TODO: fix the bug, when the number of user likes less than 10, the array index passed
class FavoriteViewController: BaseViewController {

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

    lazy var homeBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "ic_menu"), for: .normal)
        btn.isEnabled = true
        btn.backgroundColor = nil
        btn.addTarget(self, action: #selector(switchHomeMode(sender:)), for: .touchUpInside)
        return btn
    }()

    var regulars = [URL]()
    var raws = [URL]()


    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //        self.navigationController?.navigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false

        self.view.addSubview(bgView)
        self.bgView.addSubview(glass)
        self.view.addSubview(kolodaView)
        self.view.addSubview(self.homeBtn)

        //retrieve data from database
        do {
            let realm = try! Realm()
            let test = realm.objects(SingleImage.self)
            self.regulars = realm.objects(SingleImage.self).value(forKey: "regulars") as! [URL]
            self.raws = realm.objects(SingleImage.self).value(forKey: "raw") as! [URL]
        } catch{

        }

        handleLayout()

    }

    override func viewDidDisappear(_ animated: Bool) {
        //        clearResourcesArray()
        self.page = 1

    }


}

// MARK:  Handle something
extension FavoriteViewController {

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

        homeBtn.snp.makeConstraints{ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
        }

    }

    func switchHomeMode(sender: UIButton){
        present(PreviewViewController(), animated: true, completion: nil)
    }
    
    
}

// MARK:  Handle the gesture and relevent function
extension FavoriteViewController: ImageDownloaderDelegate{
    //MARK: config gesture function
    func swipeUp(index: Int){

    }

    func swipeLeft(index: Int){

    }

    func swipeRight(index: Int){

        let image = SingleImage()
        image.id = ImageManager.ids[index]
        image.regular = ImageManager.regulars[index].absoluteString
        image.full = ImageManager.fulls[index].absoluteString
        image.raw = ImageManager.raws[index].absoluteString
        let realm = try! Realm()
        try! realm.write {
            realm.delete(image)
        }

    }


    func swipeDown(index: Int){

        let downloader =  KingfisherManager.shared.downloader
        downloader.delegate = self
        downloader.downloadTimeout = 1


        downloader.downloadImage(
            with: self.raws[index],
            options: nil,
            progressBlock: { (receivedSize, totalSize) in
                //
        }, completionHandler: { (image, error, imageURL, originalData) in
            if error == nil {
                HUD.flash(.labeledSuccess(title: "Download Success", subtitle: nil), delay: 0.5, completion: nil)
            }

        })


    }

    func ShowShareEditor(index: Int) {

    }

}
// MARK: handle the animations in four direction

//MARK: KolodaViewDelegate
extension FavoriteViewController: KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left,.right,.up,.down]
    }
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        print(direction.hashValue)

        if direction == SwipeResultDirection.up{
            ShowShareEditor(index: Int(index))
            //            upAnimation()
            return false
        }
        if direction == SwipeResultDirection.left{
            //            leftAnimation()
            return true

        }
        if direction == SwipeResultDirection.down{
            //            downAnimation()

            return true
        }
        if direction == SwipeResultDirection.right{
            //            rightAnimation()
            return true
        }

        return false
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.up{
            swipeUp(index: Int(index))
            print("listen up")
        }
        if direction == SwipeResultDirection.left{
            swipeLeft(index: Int(index))
            print("listen left")
        }

        if direction == SwipeResultDirection.right{
            swipeRight(index: Int(index))
            print("listen right")
        }
        if direction == SwipeResultDirection.down{
            swipeDown(index: Int(index))
            print("listen down")
        }
//        if index%96 == 0 {
//            page += 1
//            ImageManager.get(page){ () -> Void in
//                self.kolodaView.reloadData()
//            }
//        }


    }

//    func kolodaDidRunOutOfCards(_ koloda: KolodaView){
//        //        kolodaView.insertCardAtIndexRange(0..<9, animated: true)
//
//        let position = kolodaView.currentCardIndex
//        ImageManager.get(page+1){ () -> Void in
//            self.kolodaView.insertCardAtIndexRange(position..<position+9,animated: true)
//            //            self.kolodaView.reloadData()
//        }
//    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int){
        if ImageManager.raws.count != 0{
            let DVC = DisplayViewController()
            DVC.imageUrl = self.raws[Int(index)]
            present(DVC, animated: true, completion: {

            })

        }
    }
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool{
        return true
    }
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool{
        return true
    }
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection){

    }
    func kolodaDidResetCard(_ koloda: KolodaView){

    }
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat?{
        return 0
    }
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int){

    }
    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int ) -> Bool{
        return true
    }

}

//MARK: KolodaViewDataSource
extension FavoriteViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {

        return self.regulars.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        var imageUrl = URL(string: "")
        var bgUrl = URL(string: "")
        //        let actualIndex = abs(index-1)%9
        if self.regulars.count != 0{
            imageUrl = self.regulars[index]
            bgUrl = self.regulars[ (Int(index)-2 > (-1)) ? Int(index-2) : 0  ]
        }

        let imageView = UIImageView()
        imageView .layer.borderColor = UIColor(red:0.98, green:0.28, blue:0.52, alpha:1.00).cgColor
        imageView .layer.borderWidth = 3
        imageView .layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named: "drop_bg"), options: nil, progressBlock: nil, completionHandler: nil)
        self.bgView.kf.setImage(with: bgUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAtIndex index: Int) -> OverlayView? {
        return nil
    }
}


