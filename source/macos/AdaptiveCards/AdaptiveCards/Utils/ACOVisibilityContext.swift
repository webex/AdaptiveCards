//
//  ACOVisibilityContext.swift
//  AdaptiveCards
//
//  Created by uchauhan on 05/09/22.
//

import AdaptiveCards_bridge
import AppKit

class ACOVisibilityContext: NSObject {
    private let visibilityMap: NSMapTable<NSString, ACSIVisibilityManagerFacade>
    
    override init() {
        visibilityMap = NSMapTable<NSString, ACSIVisibilityManagerFacade>(keyOptions: .strongMemory, valueOptions: .weakMemory)
        super.init()
    }
    
    func registerVisibilityManager(_ manager: ACSIVisibilityManagerFacade?, targetViewIdentifier viewId: NSUserInterfaceItemIdentifier?) {
        guard let manager = manager, let viewId = viewId else {
            return
        }
        visibilityMap.setObject(manager, forKey: NSString(string: viewId.rawValue))
    }

    func retrieveVisiblityManager(withIdentifier viewId: NSUserInterfaceItemIdentifier?) -> ACSIVisibilityManagerFacade? {
        guard let viewId = viewId else {
            return nil
        }
        let manager = visibilityMap.object(forKey: NSString(string: viewId.rawValue))
        return manager
    }
}
