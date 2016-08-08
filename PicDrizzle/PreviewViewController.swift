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
            frame: CGRectZero,
            normalIcon:"ic_menu",
            selectedIcon:"ic_close",
            buttonsCount: 5,
            duration: 4,
            distance: 60)
        button.delegate = self
        button.backgroundColor = UIColor.blueColor()
        button.layer.cornerRadius = button.frame.size.width / 2.0
        return button
    }()
    
    lazy var koladaImageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
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
        let effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let view = UIVisualEffectView(effect: effect)
        view.frame.size = CGSize(width: WIDTH, height: HEIGHT)
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    lazy var dropView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rain_bg")
        view.alpha = 0.8
        view.contentMode = .ScaleAspectFill
        view.backgroundColor = nil
        return view
    }()
    
    lazy var trashBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        //        btn.hidden = true
        btn.alpha = 0
        btn.imageView?.image = UIImage(named: "ic_close")
        btn.enabled = false
        btn.backgroundColor = UIColor.blueColor()
        return btn
    }()
    
    lazy var likeBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        //        btn.hidden = true
        btn.alpha = 0.8
        btn.imageView?.image = UIImage(named: "ic_favorite")
        btn.enabled = false
        btn.backgroundColor = nil
        return btn
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        //        btn.hidden = true
        btn.alpha = 0.8
        btn.imageView?.image = UIImage(named: "ic_share")
        btn.enabled = false
        btn.backgroundColor = nil
        return btn
    }()
    
    lazy var downloadBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        //        btn.hidden = true
        btn.alpha = 0.8
        btn.imageView?.image = UIImage(named: "ic_download")
        btn.enabled = false
        btn.backgroundColor = nil
        return btn
    }()
    
    
    //    lazy var swipeRight: UISwipeGestureRecognizer = {
    //        let swipe = UISwipeGestureRecognizer()
    //        swipe.direction = .Right
    //        swipe.numberOfTouchesRequired = 1
    //        swipe.addTarget(self, action: #selector(swipeRight(_:)))
    //        return swipe
    //    }()
    
    
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
                    
                    self.thumbs.append(NSURL(string: urls["thumb"].string!)!)
                    self.smalls.append(NSURL(string: urls["small"].string!)!)
                    self.regulars.append(NSURL(string: urls["regular"].string!)!)
                    self.fulls.append(NSURL(string: urls["full"].string!)!)
                    self.raws.append(NSURL(string: urls["raw"].string!)!)
                    self.kolodaView.reloadData()
                }
            }
        }
    }
    
    var ids = [String]()
    var thumbs = [NSURL]()
    var smalls = [NSURL]()
    var regulars = [NSURL]()
    var fulls = [NSURL](){
        didSet{
            //            preFetchData()
        }
    }
    var raws:[NSURL] = [NSURL](){
        didSet{
            //            preFetchData()
        }
    }
    
    
    var likeList = Set<SingleImage>()
    var trashList = [NSURL]()
    var downList = [NSURL]()
    var uploadList = [NSURL]()
    
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
        self.navigationController?.navigationBarHidden = false
        
        self.view.addSubview(bgView)
        self.bgView.addSubview(glass)
        //        self.bgView.addSubview(dropView)
        isHomePage ? self.view.addSubview(menuBtn) : print()
        self.view.addSubview(kolodaView)
        self.view.addSubview(trashBtn)
        self.view.addSubview(likeBtn)
        self.view.addSubview(shareBtn)
        self.view.addSubview(downloadBtn)
        //        isHomePage ? self.navigationController?.navigationBar.alpha = 0 : debugPrint("forbid")
        Defaults[.username] = "crazyatlantis"
        chooseTarget()
        
        handleLayout()
        //        testgetResources(page)
        
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
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
    func getResources(target: PDService){
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
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
        
        glass.snp_makeConstraints { make in
            make.edges.equalTo(self.bgView).inset(UIEdgeInsetsZero)
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
        
        trashBtn.snp_makeConstraints{ make in
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
    
    
    func preFetchData(){
        
        
        let prefetcher = ImagePrefetcher(urls: self.fulls, optionsInfo: nil, progressBlock: nil, completionHandler: {
            (skippedResources, failedResources, completedResources) -> () in
            print("These resources are prefetched: \(completedResources)")
        })
        
        prefetcher.start()
        
    }
    
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
    func swipeUp(index: Int){
        
        //        ShowShareEditor(index)
        
    }
    
    func swipeLeft(index: Int){
        if self.smalls.count>0{
            self.trashList.append(self.smalls[index])
        }
        
        UIView.animateWithDuration(0.1, delay: 0.5, options: [], animations: {
            self.trashBtn.hidden = false
            self.trashBtn.backgroundColor = UIColor.redColor()
            self.trashBtn.alpha = 1
        }) { (_) in
            self.trashBtn.hidden = true
        }
        
    }
    
    func swipeRight(index: Int){
        if isHomePage{
            if self.smalls[index] != "" {
                self.likeList.insert(SingleImage(id: self.ids[index], thumb: self.thumbs[index], small: self.smalls[index], regular: self.regulars[index], full: self.fulls[index], raw: self.raws[index]))
            }
            
            getResources(.likePhoto(photoID: self.ids[index]))
            
            UIView.animateWithDuration(0.1, delay: 0.5, options: [], animations: {
                self.likeBtn.hidden = false
                self.likeBtn.alpha = 1
            }) { (_) in
                self.likeBtn.hidden = true
            }
        } else {
            getResources(.unlikePhoto(photoID: self.ids[index]))
        }
    }
    
    
    func swipeDown(index: Int){
        self.downList.append(self.smalls[index])
        let downloader =  KingfisherManager.sharedManager.downloader
        downloader.delegate = self
        downloader.downloadTimeout = 5
        
        for url in self.downList {
            downloader.downloadImageWithURL(
                url,
                options: nil,
                progressBlock: { (receivedSize, totalSize) in
                    //
                }, completionHandler: { (image, error, imageURL, originalData) in
                    if self.downList == [] {
                        HUD.flash(.LabeledSuccess(title: "Download Success", subtitle: nil), delay: 0.5, completion: nil)
                    }
                    
            })
        }
        
        UIView.animateWithDuration(0.1, delay: 0.5, options: [], animations: {
            self.downloadBtn.hidden = false
            self.downloadBtn.alpha = 1
        }) { (_) in
            self.downloadBtn.hidden = true
        }
    }
    
    func imageDownloader(downloader: ImageDownloader, didDownloadImage image: Image, forURL URL: NSURL, withResponse response: NSURLResponse) {
        if let index = self.downList.indexOf(URL){
            
            self.downList.removeAtIndex(index)
        }
    }
    
    func ShowShareEditor(index: Int) {
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        if smalls.count == 0 {
            return
        }
        
        shareParames.SSDKSetupShareParamsByText("add some comments on this picture",
                                                images : UIImage(data: NSData(contentsOfURL: self.smalls[index])!) ,
                                                url : NSURL(string:"http://mob.com"),
                                                title : "Share Picture to",
                                                type : SSDKContentType.Auto)
        //2.进行分享
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("分享成功")
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
        
        
    }
    
}

// MARK:  CircleMenu config
extension PreviewViewController: CircleMenuDelegate{
    
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)
        
        // set highlited image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        if atIndex == 4 {
            self.navigationController?.pushViewController(PreviewViewController(isHomePage: false), animated: true)
            //            self.navigationBar.
        }
    }
    
}

//MARK: KolodaViewDelegate
extension PreviewViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //        dataSource.insert(UIImage(named: "Card_like_6")!, atIndex: kolodaView.currentCardIndex - 1)
        //        let position = kolodaView.currentCardIndex
        //        kolodaView.insertCardAtIndexRange(position...position, animated: true)
        //        clearResourcesArray()
        //        testgetResources(2)
        //        
        //        kolodaView.insertCardAtIndexRange(0...9, animated: true)
        //        kolodaView.reloadData()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        if self.smalls.count != 0{
            let DVC = DisplayViewController()
            DVC.imageUrl = self.smalls[Int(index)]
            presentViewController(DVC, animated: true, completion: { 
                
            })
            
        }
    }
    
    func koloda(koloda: KolodaView, allowedDirectionsForIndex index: UInt) -> [SwipeResultDirection] {
        return [.Left,.Right,.Up,.Down]
    }
    
    func koloda(koloda: KolodaView, shouldSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) -> Bool {
        print(direction.hashValue)
        
        if direction == SwipeResultDirection.Up{
            ShowShareEditor(Int(index))
            return false
        }
        if direction == SwipeResultDirection.Left{
            UIView.animateWithDuration(0.1, delay: 0.5, options: [], animations: {
                self.view.bringSubviewToFront(self.trashBtn)
                self.trashBtn.hidden = false
                self.trashBtn.backgroundColor = UIColor.redColor()
                self.trashBtn.alpha = 1
            }) { (_) in
                self.trashBtn.hidden = true
            }
            return true
            
        }
        if direction == SwipeResultDirection.Down{
            swipeDown(Int(index))
            return false
        }
        if direction == SwipeResultDirection.Right{
            return true 
        }
        return false
    }
    
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.Up{
            swipeUp(Int(index))
            print("listen up")
        }
        if direction == SwipeResultDirection.Left{
            swipeLeft(Int(index))
            print("listen left")
        }
        
        if direction == SwipeResultDirection.Right{
            swipeRight(Int(index))
            print("listen right")
        }
        if direction == SwipeResultDirection.Down{
            //            swipeDown(Int(index))
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
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(smalls.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        
        var imageUrl = NSURL()
        var bgUrl = NSURL()
        if self.smalls.count != 0{
            
            imageUrl = self.smalls[Int(index)]
            bgUrl = self.smalls[ (Int(index)-2 > (-1)) ? Int(index-2) : 0  ]
            
        }
        
        let imageView = UIImageView()
        imageView .layer.borderColor = UIColor.darkGrayColor().CGColor
        imageView .layer.borderWidth = 4
        imageView .layer.cornerRadius = 3
        imageView.kf_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "drop_bg"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        self.bgView.kf_setImageWithURL(bgUrl, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        return imageView
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        //        return NSBundle.mainBundle().loadNibNamed("OverlayView",
        //                                                  owner: self, options: nil)[0] as? OverlayView
        return nil
    }
}
