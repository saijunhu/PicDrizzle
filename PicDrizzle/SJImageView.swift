////
////  SJImageView.swift
////  PicDrizzle
////
////  Created by 胡胡赛军 on 8/7/16.
////  Copyright © 2016 胡胡赛军. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class SJImageView: UIView {
//    
//    private let windowBounds = UIScreen.mainScreen().bounds
//    private let SJMaxZoomScale = 2.5
//    private let SJMinZoomScale = 1.0
//    
//    var imageUrl = NSURL()
//    
//    var closeBtn: UIButton = {
//        let btn = UIButton(type: UIButtonType.Custom)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.alpha = 0
//        let image = UIImage(named: "Close")
//        btn.setImage(image, forState: .Normal)
////        btn.addTarget(self, action: #selector(closeClicked(_:)), forControlEvents: .TouchUpInside)
//        self.setNeedsUpdateConstraints()
//        return btn
//    }()
//    
//    var scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.frame = windowBounds
//        view.maximumZoomScale = SJMaxZoomScale
//        view.minimumZoomScale = SJMinZoomScale
//        view.zoomBouncing = true
//        view.delegate = self
//        return view
//    }()
//    
//    var imageView: UIImageView = {
//        let view = UIImageView()
//        view.frame = windowBounds
//        view.userInteractionEnabled = true
//        view.contentMode = .ScaleAspectFit
//        return view
//    }()
//    
//    init(frame: CGRect, color: UIColor) {
//        super.init(frame: frame)
//
//        
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configView(){
//        self.addSubview(closeBtn)
//        self.addSubview(scrollView)
//        self.scrollView.addSubview(imageView)
//        
//        closeBtn.addTarget(self, action: #selector(closeClicked(_:)), forControlEvents: .TouchUpInside)
//        
//    }
//    
//    func handleLayout(){
//        
//    }
//    func closeClicked(sender: UIButton){
//        
//    }
//    private func configureConstraints() {
//        var constraints: [NSLayoutConstraint] = []
//        
//        let views: [String: UIView] = [
//            "closeButton": closeButton
//        ]
//        
//        constraints.append(NSLayoutConstraint(item: closeButton, attribute: .CenterX, relatedBy: .Equal, toItem: closeButton.superview, attribute: .CenterX, multiplier: 1.0, constant: 0))
//        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeButton(==64)]-40-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
//        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:[closeButton(==64)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
//        
//        NSLayoutConstraint.activateConstraints(constraints)
//    }
//    
//    // MARK: - Gestures
//    private func addPanGestureToView() {
//        panGesture = UIPanGestureRecognizer(target: self, action: "gestureRecognizerDidPan:")
//        panGesture.cancelsTouchesInView = false
//        panGesture.delegate = self
//        
//        imageView.addGestureRecognizer(panGesture)
//    }
//    
//    private func addGestures() {
//        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "didSingleTap:")
//        singleTapRecognizer.numberOfTapsRequired = 1
//        singleTapRecognizer.numberOfTouchesRequired = 1
//        scrollView.addGestureRecognizer(singleTapRecognizer)
//        
//        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "didDoubleTap:")
//        doubleTapRecognizer.numberOfTapsRequired = 2
//        doubleTapRecognizer.numberOfTouchesRequired = 1
//        scrollView.addGestureRecognizer(doubleTapRecognizer)
//        
//        singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
//    }
//    
//    private func zoomInZoomOut(point: CGPoint) {
//        let newZoomScale = scrollView.zoomScale > (scrollView.maximumZoomScale / 2) ? scrollView.minimumZoomScale : scrollView.maximumZoomScale
//        
//        let scrollViewSize = scrollView.bounds.size
//        let w = scrollViewSize.width / newZoomScale
//        let h = scrollViewSize.height / newZoomScale
//        let x = point.x - (w / 2.0)
//        let y = point.y - (h / 2.0)
//        
//        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
//        
//        scrollView.zoomToRect(rectToZoomTo, animated: true)
//    }
//    private func centerFrameFromImage(image: UIImage) -> CGRect {
//        var newImageSize = imageResizeBaseOnWidth(windowBounds.size.width, oldWidth: image.size.width, oldHeight: image.size.height)
//        newImageSize.height = min(windowBounds.size.height, newImageSize.height)
//        
//        return CGRect(x: 0, y: windowBounds.size.height / 2 - newImageSize.height / 2, width: newImageSize.width, height: newImageSize.height)
//    }
//    
//    private func imageResizeBaseOnWidth(newWidth: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGSize {
//        let scaleFactor = newWidth / oldWidth
//        let newHeight = oldHeight * scaleFactor
//        
//        return CGSize(width: newWidth, height: newHeight)
//    }
//    
//    // MARK: - Actions
//    func gestureRecognizerDidPan(recognizer: UIPanGestureRecognizer) {
//        if scrollView.zoomScale != 1.0 || isAnimating {
//            return
//        }
//        
//        senderView.alpha = 0.0
//        
//        scrollView.bounces = false
//        let windowSize = maskView.bounds.size
//        let currentPoint = panGesture.translationInView(scrollView)
//        let y = currentPoint.y + panOrigin.y
//        
//        imageView.frame.origin = CGPoint(x: currentPoint.x + panOrigin.x, y: y)
//        
//        let yDiff = abs((y + imageView.frame.size.height / 2) - windowSize.height / 2)
//        maskView.alpha = max(1 - yDiff / (windowSize.height / 0.95), kMinMaskViewAlpha)
//        closeButton.alpha = max(1 - yDiff / (windowSize.height / 0.95), kMinMaskViewAlpha) / 2
//        
//        if (panGesture.state == UIGestureRecognizerState.Ended || panGesture.state == UIGestureRecognizerState.Cancelled)
//            && scrollView.zoomScale == 1.0 {
//            maskView.alpha < 0.85 ? dismissViewController() : rollbackViewController()
//        }
//    }
//    
//    func didSingleTap(recognizer: UITapGestureRecognizer) {
//        scrollView.zoomScale == 1.0 ? dismissViewController() : scrollView.setZoomScale(1.0, animated: true)
//    }
//    
//    func didDoubleTap(recognizer: UITapGestureRecognizer) {
//        let pointInView = recognizer.locationInView(imageView)
//        zoomInZoomOut(pointInView)
//    }
//    
//    func closeButtonTapped(sender: UIButton) {
//        if scrollView.zoomScale != 1.0 {
//            scrollView.setZoomScale(1.0, animated: true)
//        }
//        dismissViewController()
//    }
//    
//    // MARK: - Misc.
//    private func centerScrollViewContents() {
//        let boundsSize = rootViewController.view.bounds.size
//        var contentsFrame = imageView.frame
//        
//        if contentsFrame.size.width < boundsSize.width {
//            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
//        } else {
//            contentsFrame.origin.x = 0.0
//        }
//        
//        if contentsFrame.size.height < boundsSize.height {
//            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
//        } else {
//            contentsFrame.origin.y = 0.0
//        }
//        
//        imageView.frame = contentsFrame
//    }
//    
//    
//}
//// MARK: - GestureRecognizer delegate
//extension ImageViewer: UIGestureRecognizerDelegate {
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        panOrigin = imageView.frame.origin
//        gestureRecognizer.enabled = true
//        return !isAnimating
//    }
//}
//
//// MARK: - ScrollView delegate
//extension ImageViewer: UIScrollViewDelegate {
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        isAnimating = true
//        centerScrollViewContents()
//    }
//    
//    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        isAnimating = false
//    }
//}