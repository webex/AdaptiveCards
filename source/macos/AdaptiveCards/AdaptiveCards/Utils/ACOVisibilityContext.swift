//
//  ACOVisibilityContext.swift
//  AdaptiveCards
//
//  Created by uchauhan on 05/09/22.
//
// This Visibility Context is used to store and retrieve specific protocol-adopted content views. This context will be preserved within a single card.

import AdaptiveCards_bridge
import AppKit

class ACOVisibilityContext: NSObject {
    /// store view with its corresponding root content view manager
    /// `Key` : View Id Store with Strong referance
    /// `Value`: corresponding root content view manager Store with Weak referance
    private let visibilityMap: NSMapTable<NSString, ACSIVisibilityManagerFacade>
    
    override init() {
        visibilityMap = NSMapTable<NSString, ACSIVisibilityManagerFacade>(keyOptions: .strongMemory, valueOptions: .weakMemory)
        super.init()
    }
    
    /// register visibility protocol with targeted view's ID
    /// - Parameters:
    ///   - manager: ACSIVisibilityManagerFacade adopted ParentView
    ///   - viewId: targeted visibility view id
    func registerVisibilityManager(_ manager: ACSIVisibilityManagerFacade?, targetViewIdentifier viewId: NSUserInterfaceItemIdentifier?) {
        guard let manager = manager, let viewId = viewId else {
            return
        }
        visibilityMap.setObject(manager, forKey: NSString(string: viewId.rawValue))
    }
    
    /// get visibility manager for targeted view.
    /// - Parameter viewId: targeted visibility view id
    /// - Returns: ACSIVisibilityManagerFacade adopted ParentView
    func retrieveVisiblityManager(withIdentifier viewId: NSUserInterfaceItemIdentifier?) -> ACSIVisibilityManagerFacade? {
        guard let viewId = viewId else {
            return nil
        }
        let manager = visibilityMap.object(forKey: NSString(string: viewId.rawValue))
        return manager
    }
}
