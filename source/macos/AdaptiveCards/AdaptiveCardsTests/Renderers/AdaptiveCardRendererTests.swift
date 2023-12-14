//
//  AdaptiveCardRendererTests.swift
//  AdaptiveCardsTests
//
//  Created by mukuagar on 13/12/23.
//

@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class AdaptiveCardRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var adaptiveCardRenderer: AdaptiveCardRenderer!
    private var rootView: FakeRootView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        adaptiveCardRenderer = AdaptiveCardRenderer()
        rootView = FakeRootView()
    }
    
    func testShowCardIdSameAsParent() {
        let parentView = FakeRootView()
        parentView.identifier = NSUserInterfaceItemIdentifier("test")
        let fakeShowCard = FakeAdaptiveCard.make()
        let showCardView = adaptiveCardRenderer.renderShowCard(fakeShowCard, with: hostConfig, parent: parentView, config: .default)
        XCTAssertEqual(parentView.identifier, showCardView.identifier)
        XCTAssertEqual(showCardView.identifier?.rawValue, "test")
    }
    
}

