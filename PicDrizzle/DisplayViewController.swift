//
//  imageViewController.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 7/16/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


let windowBounds = UIScreen.mainScreen().bounds
let SJMaxZoomScale: CGFloat = 2.0
let SJMinZoomScale: CGFloat = 1.0

class DisplayViewController: BaseViewController {
    
    
    var isChangeFrame = false
    var imageUrl = NSURL()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.userInteractionEnabled = true
        imageView.clipsToBounds = false
        imageView.backgroundColor = UIColor.cyanColor()
        return imageView
        
     }()

    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 0
        btn.enabled = false
        let image = UIImage(named: "Close")
        btn.setImage(image, forState: .Normal)
        btn.addTarget(self, action: #selector(closeBtnClosed(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = windowBounds
        view.contentMode = .Center
        view.maximumZoomScale = SJMaxZoomScale
        view.minimumZoomScale = SJMinZoomScale
        view.bounces = true
        view.bouncesZoom = true
        view.showsVerticalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    lazy var tapOne: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(tapOne(_:)))
        return tap
    }()
    
    lazy var tapTwice: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(tapTwice(_:)))
        return tap
        
    }()
    
    
    lazy var pan: UIPanGestureRecognizer = {
        let p = UIPanGestureRecognizer()
        p.cancelsTouchesInView = false
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
        configView()
        handleLayout()
        imageView.kf_setImageWithURL(self.imageUrl, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            
        }

    }
    //MARK: config layout
    
    func configView(){
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        scrollView.delegate = self

        self.view.addSubview(scrollView)
        self.view.addSubview(closeBtn)
        scrollView.addSubview(imageView)
        imageView.addGestureRecognizer(tapOne)
        tapOne.requireGestureRecognizerToFail(tapTwice)
        imageView.addGestureRecognizer(tapTwice)
        imageView.addGestureRecognizer(pan)
        imageView.addGestureRecognizer(pinch)
        imageView.addGestureRecognizer(rotation)
    }
    
    func handleLayout(){
        
        self.scrollView.snp_makeConstraints {  make in
            make.center.equalTo(self.view)
            make.edges.equalTo(self.view.snp_edges).offset(UIEdgeInsetsZero)
        }
        
        self.imageView.snp_makeConstraints{ make in
            make.centerX.equalTo(self.scrollView.snp_centerX)
            make.centerY.equalTo(self.scrollView.snp_centerY)
        }
        self.closeBtn.snp_makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
        }
        
    }
    
    func closeBtnClosed(sender: UIButton){
        if scrollView.zoomScale != 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: config gesture
    
    func tapOne(tap: UITapGestureRecognizer){

        
        if closeBtn.enabled {
            UIView.animateWithDuration(0.5, animations: {
                self.closeBtn.alpha = 0
                }) { (_) in
                    self.closeBtn.enabled =  false
            }
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.closeBtn.alpha = 1
                }, completion: { (_) in
                    self.closeBtn.enabled = true
            })
        }
        


        print("single tap")
    }
    
    func tapTwice(tap: UITapGestureRecognizer){

        if scrollView.zoomScale == 1.0 {
            scrollView.setZoomScale(SJMaxZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(SJMinZoomScale, animated: true)
            
        }
        
        
        print("tap twice")
    }
    
    func pan(pan: UIPanGestureRecognizer){
        if pan.state == UIGestureRecognizerState.Began || pan.state == UIGestureRecognizerState.Changed {
            
            let translation = pan.translationInView(imageView.superview!)
            imageView.center = CGPointMake(imageView.center.x + translation.x, imageView.center.y + translation.y)
            //以前aImageView当前位置来作为aImageView的初始位置
            pan.setTranslation(CGPointZero, inView: imageView.superview)
        }
        print("pan")
    }
    
    func pinch(pinch: UIPinchGestureRecognizer){
        if pinch.state == .Began || pinch.state == .Changed {
//            imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale)
            //以当前scale来作为gestureRecognizer.scale的初始值
            scrollView.setZoomScale(pinch.scale, animated: true)
            pinch.scale = 1
        }
        print("pinch")
    }
    
    func rotation(rotation: UIRotationGestureRecognizer){
        if rotation.state == .Began || rotation.state == .Changed {
            imageView.transform = CGAffineTransformRotate(imageView.transform, rotation.rotation)
            //以当前rotation值来作为gestureRecognizer的初始值
            rotation.rotation = 0
        }
        print("rotation")
    }
    
    
}
extension DisplayViewController: UIScrollViewDelegate{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {

    }
    
}
