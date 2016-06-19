//
//  LinksFactory.swift
//  LinksControllerExample
//
//  Created by David Rico Nieto on 19/06/2016.
//  Copyright © 2016 David Rico Nieto. All rights reserved.
//

import Foundation

struct CommonLinkActionsFactory: LinksActionFactory {
    
    func actions() -> [LinksAction.Type] {
        return [OpenUserProfileLinkAction.self, ShowAnotherTabLinkAction.self]
    }
}