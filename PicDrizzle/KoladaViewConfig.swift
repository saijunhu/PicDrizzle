//
//  KodaViewConfigure.swift
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
// MARK:  Handle the gesture and relevent function

enum DatabaseError: Swift.Error {
    case DuplicatedValue
}


extension PreviewViewController: ImageDownloaderDelegate{
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

        do {
            let realm = try Realm()

            try realm.write {
                realm.add(image)
            }
        }catch{

        }



    }


    func swipeDown(index: Int){

        let downloader =  KingfisherManager.shared.downloader
        downloader.delegate = self
        downloader.downloadTimeout = 1


        downloader.downloadImage(
            with: ImageManager.raws[index],
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
extension PreviewViewController: KolodaViewDelegate {
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
        if index%96 == 0 {
            page += 1
            ImageManager.get(page){ () -> Void in
                self.kolodaView.reloadData()
            }
        }


    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView){
//        kolodaView.insertCardAtIndexRange(0..<9, animated: true)

        let position = kolodaView.currentCardIndex
        ImageManager.get(page+1){ () -> Void in
            self.kolodaView.insertCardAtIndexRange(position..<position+9,animated: true)
//            self.kolodaView.reloadData()
        }
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int){
        if ImageManager.raws.count != 0{
            let DVC = DisplayViewController()
            DVC.imageUrl = ImageManager.raws[Int(index)]
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
extension PreviewViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        let count = ImageManager.regulars.count
        return ImageManager.regulars.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        var imageUrl = URL(string: "")
        var bgUrl = URL(string: "")
//        let actualIndex = abs(index-1)%9
        if ImageManager.regulars.count != 0{
            imageUrl = ImageManager.regulars[index]
            bgUrl = ImageManager.regulars[ (Int(index)-2 > (-1)) ? Int(index-2) : 0  ]

        }

        let imageView = UIImageView()
        imageView .layer.borderColor = UIColor ( red: 0.702, green: 0.702, blue: 0.702, alpha: 1.0 ).cgColor
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
