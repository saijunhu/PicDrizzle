//
//  PreViewAnimation.swift
//  PicDrizzle
//
//  Created by plusub on 19/03/2017.
//  Copyright © 2017 胡胡赛军. All rights reserved.
//

import Foundation


//extension PreviewViewController {
//    func upAnimation() {
//        self.animationView.frame = CGRect(x: 0,y: 0, width:WIDTH, height:20)
//        self.animationView.backgroundColor = UIColor.blue
//        self.view.insertSubview(animationView, belowSubview: self.shareBtn)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       options: UIViewAnimationOptions.curveEaseIn,
//                       animations: {
//                        self.animationView.alpha = 0
//                        self.shareBtn.alpha = 0
//        }) { (_) in
//            self.animationView.removeFromSuperview()
//            self.animationView.alpha = 1
//            self.shareBtn.alpha = 1
//        }
//    }
//
//    func downAnimation() {
//        self.animationView.frame = CGRect(x:0, y:HEIGHT+20, width:WIDTH, height:20)
//        self.animationView.backgroundColor = UIColor ( red: 0.3039, green: 0.68, blue: 0.2898, alpha: 1.0 )
//        self.view.insertSubview(animationView, belowSubview: self.downloadBtn)
//
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       options: UIViewAnimationOptions.curveEaseIn,
//                       animations: {
//                        self.animationView.alpha = 0
//                        self.downloadBtn.alpha = 0
//                        //                                    self.animationView.frame.size.height -= 20
//                        self.animationView.center.y = HEIGHT-10
//        }) { (_) in
//            self.animationView.removeFromSuperview()
//            self.animationView.alpha = 1
//            self.shareBtn.alpha = 1
//        }
//    }
//
//    func leftAnimation() {
//        self.animationView.frame = CGRect(x:-20, y:0, width:20 , height:HEIGHT)
//        self.animationView.backgroundColor = UIColor ( red: 0.92, green: 0.618, blue: 0.2425, alpha: 1.0 )
//        self.view.insertSubview(animationView, belowSubview: self.passBtn)
//
//        UIView.animate(withDuration: 0.8,
//                       delay: 0,
//                       options: UIViewAnimationOptions.curveEaseIn,
//                       animations: {
//                        self.animationView.alpha = 0
//                        self.passBtn.alpha = 0
//                        self.animationView.center.x = 10
//        }) { (_) in
//            self.animationView.removeFromSuperview()
//            self.animationView.alpha = 1
//            self.shareBtn.alpha = 1
//        }
//
//    }
//
//    func rightAnimation() {
//        self.animationView.frame = CGRect(x:WIDTH+20,y: 0 , width:20, height:HEIGHT)
//        self.animationView.backgroundColor = isHomePage ? UIColor.init(red: 0.2073, green: 0.4638, blue: 0.7454, alpha: 1.0) : UIColor ( red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1.0 )
//        self.view.insertSubview(animationView, belowSubview: self.likeBtn)
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       options: UIViewAnimationOptions.curveEaseIn,
//                       animations: {
//                        self.animationView.alpha = 0
//                        self.likeBtn.alpha = 0
//                        self.animationView.center.x = WIDTH-10
//        }) { (_) in
//            self.animationView.removeFromSuperview()
//            self.animationView.alpha = 1
//            self.shareBtn.alpha = 1
//        }
//
//    }
//}
