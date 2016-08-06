//
//  DisplayViewController.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 7/16/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class DisplayViewController: BaseViewController {
    
    
    var isChangeFrame = false
    var imageUrl = NSURL()
    
    lazy var displayView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.cyanColor()
        return imageView
        
     }()
    
    lazy var tapOne: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(tapOne(_:)))
        return tap
    }()
    
    lazy var tapTwice: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.addTarget(self, action: #selector(tapTwice(_:)))
        return tap
        
    }()
    
    
    lazy var pan: UIPanGestureRecognizer = {
        let p = UIPanGestureRecognizer()
        p.addTarget(self, action: #selector(pan(_:)))
        return p
        
    }()
    
    lazy var pinch: UIPinchGestureRecognizer = {
        let pin = UIPinchGestureRecognizer()
        
        pin.addTarget(self, action: #selector(pinch(_:)))
        return pin
    }()
    
    lazy var rotation: UIRotationGestureRecognizer = {
        let r = UIRotationGestureRecognizer()
        r.addTarget(self, action: #selector(rotation(_:)))
        return r
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(displayView)
        displayView.addGestureRecognizer(tapOne)
        displayView.addGestureRecognizer(tapTwice)
        displayView.addGestureRecognizer(pan)
        displayView.addGestureRecognizer(pinch)
        displayView.addGestureRecognizer(rotation)
        
        handleLayout()
        displayView.kf_setImageWithURL(self.imageUrl, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            
        }
    }
    //MARK: config layout
    
    func handleLayout(){
        self.displayView.snp_makeConstraints{ make in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
        
    }
    
    //MARK: config gesture
    
    func tapOne(tap: UITapGestureRecognizer){
        
        print("tap")
    }
    
    func tapTwice(tap: UITapGestureRecognizer){
        var frame = displayView.frame
        if !isChangeFrame {
            frame.size.width *= 2
            frame.size.height *= 2
            
            isChangeFrame = true
        } else {
            frame.size.width /= 2
            frame.size.height /= 2
            isChangeFrame = false
        }
        displayView.frame = frame
        print("tap twice")
    }
    
    func pan(pan: UIPanGestureRecognizer){
        if pan.state == UIGestureRecognizerState.Began || pan.state == UIGestureRecognizerState.Changed {
            
            let translation = pan.translationInView(displayView.superview!)
            displayView.center = CGPointMake(displayView.center.x + translation.x, displayView.center.y + translation.y)
            //以前aImageView当前位置来作为aImageView的初始位置
            pan.setTranslation(CGPointZero, inView: displayView.superview)
        }
        print("pan")
    }
    
    func pinch(pinch: UIPinchGestureRecognizer){
        if pinch.state == .Began || pinch.state == .Changed {
            displayView.transform = CGAffineTransformScale(displayView.transform, pinch.scale, pinch.scale)
            //以当前scale来作为gestureRecognizer.scale的初始值
            pinch.scale = 1
        }
        print("pinch")
    }
    
    func rotation(rotation: UIRotationGestureRecognizer){
        if rotation.state == .Began || rotation.state == .Changed {
            displayView.transform = CGAffineTransformRotate(displayView.transform, rotation.rotation)
            //以当前rotation值来作为gestureRecognizer的初始值
            rotation.rotation = 0
        }
        print("rotation")
    }
    
}
