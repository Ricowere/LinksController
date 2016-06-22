//
//  LinkActions.swift
//  LinksControllerExample
//
//  Created by David Rico Nieto on 19/06/2016.
//  Copyright © 2016 David Rico Nieto. All rights reserved.
//

import Foundation

import UIKit

struct OpenUserProfileLinkAction: LinksAction {
    
    static func linkActionSchemeMap() -> [String : [String]] {
        return [ "my-app" : ["profile"],
                 "www.my-server.com" : ["profile/:id_user", "from/twitter/user/:id_user"],
                 "subdomain.my-server.com" : ["colleague/:id_user"]
                ]
    }
    
    static func linkActionHandler() -> LinksActionHandler {
        return { parameters in
            
            guard let rootViewController = parameters[LinkParameters.rootViewController] as? UIViewController else {
                return false
            }
            
            let profileViewController = UIViewController()
            
            if let view = profileViewController.view {
                view.backgroundColor = .brownColor()
            }
            
            rootViewController.presentViewController(profileViewController,
                                                     animated: true,
                                                     completion: nil)

            return true
        }
    }
}

struct ShowAnotherTabLinkAction: LinksAction {
    
    static func linkActionSchemeMap() -> [String : [String]] {
        return [ "my-app" : ["show_tab_option/:option"]]
    }
    
    static func linkActionHandler() -> LinksActionHandler {
        return { parameters in
            
            guard let option = parameters["option"] as? String,
                  let rootViewController = parameters[LinkParameters.rootViewController] as? UITabBarController else {
                return false
            }
            
            switch option {
            case "option1":
                rootViewController.selectedIndex = 0
                
            case "option2":
                rootViewController.selectedIndex = 1
                
            default:
                return false
            }
            
            return true
        }
    }
}