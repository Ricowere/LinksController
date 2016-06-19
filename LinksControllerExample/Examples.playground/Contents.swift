//: Playground - noun: a place where people can play

import UIKit
import JLRoutes

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

    
struct FooAction: LinksAction {
    
    static func linkActionSchemeMap() -> [String : [String]] {
        return [ "defaultSchema" : ["foo/bar/:parameter", "foo/res"]]
    }
    
    static func linkActionHandler() -> LinksActionHandler {
        return { LinksActionHandlerParameters in
            return true
        }
    }
}

struct FooFactory: LinksActionFactory {

    func actions() -> [LinksAction.Type] {
        return [FooAction.self]
    }
}

let DEBUG = "DEBUG"

let routesController = ThirdPartyLinksController(factory: FooFactory())
routesController.takeOff()

routesController.routeURL(NSURL(string: "defaultSchema://foo/res")!)


//NSString * kBSUGenericLinkApplicationOpenURLGooglePlusNotification;
//NSString * kBSUGenericLinkApplicationOpenURLFacebookNotification;
//
//extern NSString * kBSUGenericLinkParametersUser;
//extern NSString * kBSUGenericLinkParametersRootViewController;
//extern NSString * kBSUGenericLinkParametersLinksController;
//
//extern NSString * kBSUGenericLinkParametersApplication;
//extern NSString * kBSUGenericLinkParametersSourceApplication;
//extern NSString * kBSUGenericLinkParametersAnnotation;
