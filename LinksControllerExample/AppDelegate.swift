//
//  AppDelegate.swift
//  LinksControllerExample
//
//  Created by David Rico Nieto on 09/06/2016.
//  Copyright © 2016 David Rico Nieto. All rights reserved.
//

import UIKit

import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let linksController: LinksController = ThirdPartyLinksController(factory: CommonLinkActionsFactory())
    
    var window: UIWindow?
    weak var tabBarController: UITabBarController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        tabBarController = self.window?.rootViewController as? UITabBarController
        
        linksController.takeOff()
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        var dict = defaultLinkControllerParameters()
        
        dict[LinkParameters.annotation] = annotation
        if let sourceApp = sourceApplication {
            dict[LinkParameters.sourceApplication] = sourceApp
        }
        
        return linksController.routeURL(url, parameters: dict)
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
    
        //
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
     
        var dict = defaultLinkControllerParameters()
        
        for (key, value) in options { dict[key] = value }
        
        return linksController.routeURL(url, parameters: options)
    }


    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        var shouldContinueUserActivity = false
        
        if let url = userActivity.webpageURL where userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            
            shouldContinueUserActivity = linksController.routeURL(url, parameters: defaultLinkControllerParameters())
        }
        
        
        if let userInfo = userActivity.userInfo,
           let actionString = userInfo[CSSearchableItemActivityIdentifier] as? String,
            let url = NSURL(string: actionString) where userActivity.activityType == CSSearchableItemActionType {
            
            shouldContinueUserActivity = linksController.routeURL(url, parameters: defaultLinkControllerParameters())
        }

        return shouldContinueUserActivity
    }
    
    private func defaultLinkControllerParameters() -> LinksActionHandlerParameters {
        var dict: [String : AnyObject] = [:]
        
        if let rootVC = tabBarController {
            dict[LinkParameters.rootViewController] = rootVC
        }
        
        dict[LinkParameters.linksController] = linksController as? NSObject
        
        return dict
    }
}

