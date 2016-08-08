//
//  AppDelegate.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 7/17/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        ShareSDK.registerApp(
            "15cb74af655a2",
            
            activePlatforms: [SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeFacebook.rawValue,
                SSDKPlatformType.TypeEvernote.rawValue,
                SSDKPlatformType.TypeSMS.rawValue,
                SSDKPlatformType.TypeDropbox.rawValue,
                SSDKPlatformType.TypeMail.rawValue,
                SSDKPlatformType.TypeTwitter.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,],
            onImport: {(platform : SSDKPlatformType) -> Void in
                
                switch platform{
                    
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                    
                case SSDKPlatformType.TypeSinaWeibo:
                    //TODO:设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("568898243",
                        appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
                        redirectUri : "http://www.sharesdk.cn",
                        authType : SSDKAuthTypeBoth)
                    break

                case SSDKPlatformType.TypeFacebook:
                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                    appInfo.SSDKSetupFacebookByApiKey(
                        "1750447768559124",
                        appSecret : "a51e114565752173a47870c4a7a256c1",
                        authType : SSDKAuthTypeBoth)
                    break
                    
                
                case SSDKPlatformType.TypeEvernote:
                    //configure evernote
                    appInfo.SSDKSetupEvernoteByConsumerKey("saijunhu", consumerSecret: "77151343e6b7e549 ", sandbox: true)
                    break
                
                case SSDKPlatformType.TypeDropbox:
                    appInfo.SSDKSetupDropboxByAppKey("42nlmapi6n65zka", appSecret: "mh9sjdx2jbmfst9", oauthCallback: "PicDrizzle://")
                    break
                    
                case SSDKPlatformType.TypeTwitter:
                    appInfo.SSDKSetupTwitterByConsumerKey("2ioP6JNwZ27XQPU3GPRwpPJ0O", consumerSecret: "OlvXUtBCAt3ergL1d04tKgKY9PGdfweTvrq8GMfaLeR2vUcPpO", redirectUri: "PicDrizzle://")
                    break
                    
                case SSDKPlatformType.TypeWechat:
                    //TODO:设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                    break
                    
                    
                default:
                    break
                    
                }
        })
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        let pVC = UINavigationController(rootViewController: PreviewViewController(isHomePage: true))
        self.window!.rootViewController = pVC
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: --- Added function
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true
    }


}

