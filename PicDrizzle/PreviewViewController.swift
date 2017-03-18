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


//TODO: fix the bug, when the number of user likes less than 10, the array index passed
class PreviewViewController: BaseViewController {
    
    var page: Int = 1
    
    var isHomePage = true
    
    lazy var menuBtn: CircleMenu = {
        let button = CircleMenu(
            frame: CGRect.zero,
            normalIcon:"ic_menu",
            selectedIcon:"ic_close",
            buttonsCount: 5,
            duration: 4,
            distance: 60)
        button.delegate = self
        button.backgroundColor = nil
        button.layer.cornerRadius = button.frame.size.width / 2.0
        return button
    }()
    
    lazy var koladaImageView: UIImageView = {
        let  view = UIImageView()
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 3
        return view
    }()
    
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
    
    lazy var dropView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rain_bg")
        view.alpha = 0.8
        view.contentMode = .scaleAspectFill
        view.backgroundColor = nil
        return view
    }()
    
    lazy var animationView:UIView = {
        let view = UIView()
        view.alpha = 1
        return view
    }()
    
    lazy var passBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        //        btn.hidden = true
        btn.alpha = 1
        btn.imageView?.image = UIImage(named: "ic_close")
        btn.isEnabled = false
        return btn
    }()
    
    lazy var likeBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        //        btn.hidden = true
        btn.alpha = 1
        btn.imageView?.image = UIImage(named: "ic_favorite")
        btn.isEnabled = false
        btn.backgroundColor = nil
        return btn
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        //        btn.hidden = true
        btn.alpha = 1
        btn.imageView?.image = UIImage(named: "ic_share")
        btn.isEnabled = false
        btn.backgroundColor = nil
        return btn
    }()
    
    lazy var downloadBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        //        btn.hidden = true
        btn.alpha = 1
        btn.imageView?.image = UIImage(named: "ic_download")
        btn.isEnabled = false
        btn.backgroundColor = nil
        return btn
    }()
    
    
    let items: [(icon: String, color: UIColor)] = [
        ("ic_back", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        ("ic_setting", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("ic_download", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        ("ic_upload", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        ("ic_favorite", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ]
    
    var dataSource: Array<UIImage> = {
        var array: Array<UIImage> = []
        return array
    }()
    
    var picURLs = Dictionary<String,String>()
    var imagesJSON: Array = [JSON](){
        
        didSet{
            if imagesJSON.count>9{
                for urls in imagesJSON{
                    
                    self.thumbs.append(NSURL(string: urls["thumb"].string!)! as URL)
                    self.smalls.append(NSURL(string: urls["small"].string!)! as URL)
                    self.regulars.append(NSURL(string: urls["regular"].string!)! as URL)
                    self.fulls.append(NSURL(string: urls["full"].string!)! as URL)
                    self.raws.append(NSURL(string: urls["raw"].string!)! as URL)
                    self.kolodaView.reloadData()
                }
            }
        }
    }
    
    var ids = [String]()
    var thumbs = [URL]()
    var smalls = [URL]()
    var regulars = [URL]()
    var fulls = [URL](){
        didSet{
            //            preFetchData()
        }
    }
    var raws:[URL] = [URL](){
        didSet{
            //            preFetchData()
        }
    }
    
    
    var likeList = Set<SingleImage>()
    var trashList = [URL]()
    var downList = [URL]()
    var uploadList = [URL]()
    
    init(isHomePage: Bool){
        super.init(nibName: nil, bundle: nil)
        self.isHomePage = isHomePage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.navigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.addSubview(bgView)
        self.bgView.addSubview(glass)
        //        self.bgView.addSubview(dropView)
        isHomePage ? self.view.addSubview(menuBtn) : print()
        self.view.addSubview(kolodaView)
        self.view.addSubview(self.shareBtn)
        self.view.addSubview(self.downloadBtn)
        self.view.addSubview(self.passBtn)
        self.view.addSubview(self.likeBtn)
        //        isHomePage ? self.navigationController?.navigationBar.alpha = 0 : debugPrint("forbid")
        Defaults[.username] = "crazyatlantis"
        chooseTarget()
        
        handleLayout()
        //        testgetResources(page)
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        clearResourcesArray()
        self.page = 1
    }
    
    
}

// MARK:  Handle something
extension PreviewViewController {
    
    func chooseTarget(){
        if isHomePage{
            getResources(.getImageResources(page: self.page))
        }else{
            getResources(.userLikePhotos(user: Defaults[.username]!, page: self.page))
        }
    }
    func getResources(_ target: PDService){
        self.imagesJSON = []
        PDNetwork.Request(target) { (jsonData) in
            //print("------------------------------json comes\(jsonData)")
            //            self.imagesURL.append(<#T##newElement: Element##Element#>)
            guard let Array = jsonData.array else {
                return
            }
            for picInfo in Array{
                self.ids.append(picInfo["id"].string ?? "")
                self.imagesJSON.append(picInfo["urls"])
            }
            print(self.imagesJSON)
        }
        
    }
    func handleLayout(){
        
        bgView.snp_makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        
        glass.snp_makeConstraints { make in
            make.edges.equalTo(self.bgView).inset(UIEdgeInsets.zero)
        }
        
        //        dropView.snp_makeConstraints { make in
        //            make.edges.equalTo(self.bgView).inset(UIEdgeInsetsZero)
        //        }
        kolodaView.snp_makeConstraints{ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(80, 40, 120, 40))
        }
        
        isHomePage ? menuBtn.snp_makeConstraints{ (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            } : debugPrint("forbid")
        
        passBtn.snp_makeConstraints{ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view.snp_centerY)
            make.left.equalTo(self.view.snp_left).offset(10)
        }
        
        likeBtn.snp_makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view.snp_centerY)
            make.right.equalTo(self.view.snp_right).offset(-10)
        }
        
        shareBtn.snp_makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(self.view.snp_top).offset(10)
        }
        
        downloadBtn.snp_makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
        }
        
        
    }
    
    
//    func preFetchData(){
//        
//        
//        let prefetcher = ImagePrefetcher(urls: self.fulls, optionsInfo: nil, progressBlock: nil, completionHandler: {
//            (skippedResources, failedResources, completedResources) -> () in
//            print("These resources are prefetched: \(completedResources)")
//        })
//        
//        prefetcher.start()
//        
//    }

    func clearResourcesArray(){
        self.thumbs = []
        self.smalls = []
        self.regulars = []
        self.fulls = []
        self.raws = []
        self.ids = []
    }
    
}

// MARK:  Handle the gesture and relevent function
extension PreviewViewController: ImageDownloaderDelegate{
    //MARK: config gesture function
    func swipeUp(_ index: Int){
        
        //        ShowShareEditor(index)
        
    }
    
    func swipeLeft(_ index: Int){
        if self.smalls.count>0{
            self.trashList.append(self.smalls[index])
        }
        
    }
    
    func swipeRight(_ index: Int){
        if isHomePage{
            if self.smalls[index].absoluteString != "" {
                self.likeList.insert(SingleImage(id: self.ids[index], thumb: self.thumbs[index], small: self.smalls[index], regular: self.regulars[index], full: self.fulls[index], raw: self.raws[index]))
            }
            
            getResources(.likePhoto(photoID: self.ids[index]))
            
        } else {
            getResources(.unlikePhoto(photoID: self.ids[index]))
        }
    }
    
    
    func swipeDown(_ index: Int){
        self.downList.append(self.smalls[index])
        let downloader =  KingfisherManager.shared.downloader
        downloader.delegate = self
        downloader.downloadTimeout = 5
        
        for url in self.downList {
            downloader.downloadImage(
                with: url,
                options: nil,
                progressBlock: { (receivedSize, totalSize) in
                    //
                }, completionHandler: { (image, error, imageURL, originalData) in
                    if self.downList == [] {
                        HUD.flash(.labeledSuccess(title: "Download Success", subtitle: nil), delay: 0.5, completion: nil)
                    }
                    
            })
        }
        
    }
    
    func imageDownloader(_ downloader: ImageDownloader, didDownloadImage image: Image, forURL URL: Foundation.URL, withResponse response: URLResponse) {
        if let index = self.downList.index(of: URL){
            
            self.downList.remove(at: index)
        }
    }
    
//    func ShowShareEditor(_ index: Int) {
//        
//        // 1.创建分享参数
//        let shareParames = NSMutableDictionary()
//        
//        if smalls.count == 0 {
//            return
//        }
//        
//        shareParames.ssdkSetupShareParams(byText: "add some comments on this picture",
//                                                images : UIImage(data: try! Data(contentsOf: self.smalls[index])) ,
//                                                url : URL(string:"http://mob.com"),
//                                                title : "Share Picture to",
//                                                type : SSDKContentType.auto)
//        //2.进行分享
//        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [AnyHashable: Any]!, contentEnity : SSDKContentEntity!, error : NSError!, end) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.success: print("分享成功")
//            case SSDKResponseState.fail:    print("分享失败,错误描述:\(error)")
//            case SSDKResponseState.cancel:  print("分享取消")
//                
//            default:
//                break
//            }
//        }
//        
//        
//    }

}
// MARK: handle the animations in four direction
extension PreviewViewController {
    func upAnimation() {
        self.animationView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 20)
        self.animationView.backgroundColor = UIColor.blue
        self.view.insertSubview(animationView, belowSubview: self.shareBtn)
        
        UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: UIViewAnimationOptions.curveEaseIn,
                                   animations: { 
                                    self.animationView.alpha = 0
                                    self.shareBtn.alpha = 0
        }) { (_) in
            self.animationView.removeFromSuperview()
            self.animationView.alpha = 1
            self.shareBtn.alpha = 1
        }
    }
    
    func downAnimation() {
        self.animationView.frame = CGRect(x: 0, y: HEIGHT+20, width: WIDTH, height: 20)
        self.animationView.backgroundColor = UIColor ( red: 0.3039, green: 0.68, blue: 0.2898, alpha: 1.0 )
        self.view.insertSubview(animationView, belowSubview: self.downloadBtn)
        
        UIView.animate(withDuration: 1,
                                   delay: 0,
                                   options: UIViewAnimationOptions.curveEaseIn,
                                   animations: {
                                    self.animationView.alpha = 0
                                    self.downloadBtn.alpha = 0
//                                    self.animationView.frame.size.height -= 20  
                                    self.animationView.center.y = HEIGHT-10
        }) { (_) in
            self.animationView.removeFromSuperview()
            self.animationView.alpha = 1
            self.shareBtn.alpha = 1
        }
    }
    
    func leftAnimation() {
        self.animationView.frame = CGRect(x: -20, y: 0, width: 20 , height: HEIGHT)
        self.animationView.backgroundColor = UIColor ( red: 0.92, green: 0.618, blue: 0.2425, alpha: 1.0 )
        self.view.insertSubview(animationView, belowSubview: self.passBtn)
        
        UIView.animate(withDuration: 0.8,
                                   delay: 0,
                                   options: UIViewAnimationOptions.curveEaseIn,
                                   animations: {
                                    self.animationView.alpha = 0
                                    self.passBtn.alpha = 0
                                    self.animationView.center.x = 10
        }) { (_) in
            self.animationView.removeFromSuperview()
            self.animationView.alpha = 1
            self.shareBtn.alpha = 1
        }
        
    }
    
    func rightAnimation() {
        self.animationView.frame = CGRect(x: WIDTH+20, y: 0 , width: 20, height: HEIGHT)
        self.animationView.backgroundColor = isHomePage ? UIColor.init(red: 0.2073, green: 0.4638, blue: 0.7454, alpha: 1.0) : UIColor ( red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1.0 )
        self.view.insertSubview(animationView, belowSubview: self.likeBtn)
        UIView.animate(withDuration: 1,
                                   delay: 0,
                                   options: UIViewAnimationOptions.curveEaseIn,
                                   animations: {
                                    self.animationView.alpha = 0
                                    self.likeBtn.alpha = 0
                                    self.animationView.center.x = WIDTH-10
        }) { (_) in
            self.animationView.removeFromSuperview()
            self.animationView.alpha = 1
            self.shareBtn.alpha = 1
        }
        
    }
}

// MARK:  CircleMenu config
extension PreviewViewController: CircleMenuDelegate{
    
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(named: items[atIndex].icon), for: UIControlState())

        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        if atIndex == 4 {
            self.navigationController?.pushViewController(PreviewViewController(isHomePage: false), animated: true)
            //            self.navigationBar.
        }
    }
    
}

//MARK: KolodaViewDelegate
extension PreviewViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //        dataSource.insert(UIImage(named: "Card_like_6")!, atIndex: kolodaView.currentCardIndex - 1)
        //        let position = kolodaView.currentCardIndex
        //        kolodaView.insertCardAtIndexRange(position...position, animated: true)
        //        clearResourcesArray()
        //        testgetResources(2)
        //        
        //        kolodaView.insertCardAtIndexRange(0...9, animated: true)
        //        kolodaView.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        if self.smalls.count != 0{
            let DVC = DisplayViewController()
            DVC.imageUrl = self.smalls[Int(index)]
            present(DVC, animated: true, completion: { 
                
            })
            
        }
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: UInt) -> [SwipeResultDirection] {
        return [.left,.right,.up,.down]
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) -> Bool {
        print(direction.hashValue)
        
        if direction == SwipeResultDirection.up{
//            ShowShareEditor(Int(index))
//            upAnimation()
            return false
        }
        if direction == SwipeResultDirection.left{
            leftAnimation()
            return true
            
        }
        if direction == SwipeResultDirection.down{
            downAnimation()
            
            return true
        }
        if direction == SwipeResultDirection.right{
            rightAnimation()
            return true 
        }
        return false
    }
    
    
    func koloda(_ koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.up{
            swipeUp(Int(index))
            print("listen up")
        }
        if direction == SwipeResultDirection.left{
            swipeLeft(Int(index))
            print("listen left")
        }
        
        if direction == SwipeResultDirection.right{
            swipeRight(Int(index))
            print("listen right")
        }
        if direction == SwipeResultDirection.down{
            swipeDown(Int(index))
            print("listen down")
        }
        //TODO : fix this problem
        if index%6 == 0 {
            page += 1
            chooseTarget()
            kolodaView.reloadData()
        }
        
        
    }
    
    
}

//MARK: KolodaViewDataSource
extension PreviewViewController: KolodaViewDataSource {
 



    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return Int(smalls.count)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        var imageUrl = URL(string: "")
        var bgUrl = URL(string: "")
        if self.smalls.count != 0{
            
            imageUrl = self.smalls[Int(index)]
            bgUrl = self.smalls[ (Int(index)-2 > (-1)) ? Int(index-2) : 0  ]
            
        }
        
        let imageView = UIImageView()
        imageView .layer.borderColor = UIColor ( red: 0.702, green: 0.702, blue: 0.702, alpha: 1.0 ).cgColor
        imageView .layer.borderWidth = 4
        imageView .layer.cornerRadius = 3
        imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "drop_bg"), options: nil, progressBlock: nil, completionHandler: nil)
        self.bgView.kf.setImage(with: bgUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAtIndex index: Int) -> OverlayView? {
        //        return NSBundle.mainBundle().loadNibNamed("OverlayView",
        //                                                  owner: self, options: nil)[0] as? OverlayView
        return nil
    }
}
