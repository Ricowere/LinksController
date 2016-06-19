//
//  ThirdPartyLinksController.swift
//  LinksControllerExample
//
//  Created by David Rico Nieto on 18/06/2016.
//  Copyright © 2016 David Rico Nieto. All rights reserved.
//

import Foundation

import JLRoutes

private enum LinksControllerOperation {
    case Register
    case Unregister
}

extension LinksControllerOperation {
    
    func execute(inScheme: String, path: String, handler: LinksActionHandler) {
        let routes = JLRoutes(forScheme: inScheme)
        
        switch self {
        case .Register:
            routes.addRoute(path, handler: handler)
            
        case .Unregister:
            routes.removeRoute(path)
        }
    }
}

class ThirdPartyLinksController: LinksController {
    let factory : LinksActionFactory
    
    //MARK: LinksController protocol
    
    required init(factory: LinksActionFactory) {
        self.factory = factory
    }
    
    func takeOff() {
        #if DEBUG
            JLRoutes.setVerboseLoggingEnabled(true)
        #endif
        
        performOperation(.Register)
    }
    
    func routeURL(url: NSURL) -> Bool {
        return JLRoutes.routeURL(url)
    }
    
    func routeURL(url: NSURL, parameters: LinksActionHandlerParameters) -> Bool {
        return JLRoutes.routeURL(url, withParameters: parameters)
    }
    
    func canRouteURL(url: NSURL) -> Bool {
        return JLRoutes.canRouteURL(url)
    }
    
    func canRouteURL(url: NSURL, parameters: LinksActionHandlerParameters) -> Bool {
        return JLRoutes.canRouteURL(url, withParameters: parameters)
    }
    
    private func performOperation(operation: LinksControllerOperation) {
        
        for action in factory.actions() {
            
            for (scheme, mapScheme) in action.linkActionSchemeMap() {
                
                for path in mapScheme {
                    
                    operation.execute(scheme,
                                      path: path,
                                      handler: action.linkActionHandler())
                }
            }
        }
    }
}