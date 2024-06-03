//
//  QueryManager.swift
//  AdaptiveCards
//
//  Created by mukuagar on 03/06/24.
//

import AdaptiveCards_bridge
import AppKit

protocol QueryResponseDelegate: AnyObject {
    func didReceiveQueryResponse(_ response: QueryResponse?)
    func didFailWithError(_ error: Error)
}

class QueryManager {
    weak var delegate: QueryResponseDelegate?
    
    func handleQueryResponse(resolverDelegate: AdaptiveCardResourceResolver?) {
        Task {
            do {
                let response = try await resolverDelegate?.adaptiveCard(NSView(), typeAheadQueryFor: "abc")
                DispatchQueue.main.async { [weak self] in
                    // Notify the delegate with the received response
                    self?.delegate?.didReceiveQueryResponse(response)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    // Notify the delegate that an error has occurred
                    self?.delegate?.didFailWithError(error)
                }
            }
        }
    }
}
