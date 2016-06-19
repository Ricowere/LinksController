//
//  LinksControllerDeclarations.swift
//  LinksControllerExample
//
//  Created by David Rico Nieto on 18/06/2016.
//  Copyright © 2016 David Rico Nieto. All rights reserved.
//

import Foundation


typealias LinksActionHandlerParameters = [NSObject : AnyObject]
typealias LinksActionHandler = (LinksActionHandlerParameters) -> (Bool)

protocol LinksAction {
    
    static func linkActionSchemeMap() -> [String : [String]]
    static func linkActionHandler() -> LinksActionHandler
    static func buildLinkWithSchema(schema: String) -> String
}

extension LinksAction {
    
    static func buildLinkWithSchema(schema: String) -> String {
        let schemeMap = linkActionSchemeMap()
        
        for (key, value) in schemeMap where key == schema {
            
            if let firstPath = value.first {
                return "\(key)://\(firstPath)"
            }
        }
        fatalError("We shouldn't reach this point, a path should be found before")
    }
}

protocol LinksActionFactory {
    
    func actions() -> [LinksAction.Type]
}

protocol LinksController {
    
    var factory: LinksActionFactory { get }
    init(factory: LinksActionFactory)
    
    func takeOff()
    
    func routeURL(url: NSURL) -> Bool
    func routeURL(url: NSURL, parameters: LinksActionHandlerParameters) -> Bool
    
    func canRouteURL(url: NSURL) -> Bool
    func canRouteURL(url: NSURL, parameters: LinksActionHandlerParameters) -> Bool
}