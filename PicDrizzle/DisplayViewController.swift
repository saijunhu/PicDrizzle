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


let windowBounds = UIScreen.main.bounds
let SJMaxZoomScale: CGFloat = 2.0
let SJMinZoomScale: CGFloat = 1.0

class DisplayViewController: BaseViewController {
    
    
    var isChangeFrame = false
    var imageUrl = URL(string: "")
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = false
        imageView.backgroundColor = UIColor.cyan
        return imageView
        
     }()

    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 0
        btn.isEnabled = false
        let image = UIImage(named: "Close")
        btn.setImage(image, for: UIControlState())
        btn.addTarget(self, action: #selector(closeBtnClosed(_:)), for: .touchUpInside)
        return btn
    }()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = windowBounds
        view.contentMode = .center
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
        imageView.kf.setImage(with: self.imageUrl, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            
        }

    }
    //MARK: config layout
    
    func configView(){
        
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        scrollView.delegate = self

        self.view.addSubview(scrollView)
        self.view.addSubview(closeBtn)
        scrollView.addSubview(imageView)
        imageView.addGestureRecognizer(tapOne)
        tapOne.require(toFail: tapTwice)
        imageView.addGestureRecognizer(tapTwice)
        imageView.addGestureRecognizer(pan)
        imageView.addGestureRecognizer(pinch)
        imageView.addGestureRecognizer(rotation)
    }
    
    func handleLayout(){
        
        self.scrollView.snp_makeConstraints {  make in
            make.center.equalTo(self.view)
            make.edges.equalTo(self.view.snp_edges).offset(UIEdgeInsets.zero as! ConstraintOffsetTarget)
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
    
    func closeBtnClosed(_ sender: UIButton){
        if scrollView.zoomScale != 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: config gesture
    
    func tapOne(_ tap: UITapGestureRecognizer){

        
        if closeBtn.isEnabled {
            UIView.animate(withDuration: 0.5, animations: {
                self.closeBtn.alpha = 0
                }, completion: { (_) in
                    self.closeBtn.isEnabled =  false
            }) 
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.closeBtn.alpha = 1
                }, completion: { (_) in
                    self.closeBtn.isEnabled = true
            })
        }
        


        print("single tap")
    }
    
    func tapTwice(_ tap: UITapGestureRecognizer){

        if scrollView.zoomScale == 1.0 {
            scrollView.setZoomScale(SJMaxZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(SJMinZoomScale, animated: true)
            
        }
        
        
        print("tap twice")
    }
    
    func pan(_ pan: UIPanGestureRecognizer){
        if pan.state == UIGestureRecognizerState.began || pan.state == UIGestureRecognizerState.changed {
            
            let translation = pan.translation(in: imageView.superview!)
            imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
            //以前aImageView当前位置来作为aImageView的初始位置
            pan.setTranslation(CGPoint.zero, in: imageView.superview)
        }
        print("pan")
    }
    
    func pinch(_ pinch: UIPinchGestureRecognizer){
        if pinch.state == .began || pinch.state == .changed {
//            imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale)
            //以当前scale来作为gestureRecognizer.scale的初始值
            scrollView.setZoomScale(pinch.scale, animated: true)
            pinch.scale = 1
        }
        print("pinch")
    }
    
    func rotation(_ rotation: UIRotationGestureRecognizer){
        if rotation.state == .began || rotation.state == .changed {
            imageView.transform = imageView.transform.rotated(by: rotation.rotation)
            //以当前rotation值来作为gestureRecognizer的初始值
            rotation.rotation = 0
        }
        print("rotation")
    }
    
    
}
extension DisplayViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

    }
    
}
