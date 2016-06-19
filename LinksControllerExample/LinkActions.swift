//
//  LinkActions.swift
//  LinksControllerExample
//
//  Created by David Rico Nieto on 19/06/2016.
//  Copyright © 2016 David Rico Nieto. All rights reserved.
//

import Foundation


struct OpenUserProfileLinkAction: LinksAction {
    
    static func linkActionSchemeMap() -> [String : [String]] {
        return [ "my-app" : ["profile"],
                 "www.my-server.com" : ["profile/:id_user", "from/twitter/user/:id_user"],
                 "subdomain.my-server.com" : ["colleague/:id_user"]
                ]
    }
    
    static func linkActionHandler() -> LinksActionHandler {
        return { LinksActionHandlerParameters in
            return true
        }
    }
}

struct ShowAnotherTabLinkAction: LinksAction {
    
    static func linkActionSchemeMap() -> [String : [String]] {
        return [ "my-app" : ["show_tab_option/option"]]
    }
    
    static func linkActionHandler() -> LinksActionHandler {
        return { LinksActionHandlerParameters in
            return true
        }
    }
}