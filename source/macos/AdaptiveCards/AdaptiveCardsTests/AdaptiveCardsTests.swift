//
//  AdaptiveCardsTests.swift
//  AdaptiveCardsTests
//
//  Created by aksc on 13/01/21.
//

@testable import AdaptiveCards
import XCTest

class AdaptiveCardsTests: XCTestCase {
    private var delegate: FakeAdaptiveCardActionDelegate!
    private var resourceResolver: FakeResourceResolver!
    
    override func setUp() {
        super.setUp()
        delegate = FakeAdaptiveCardActionDelegate()
        resourceResolver = FakeResourceResolver()
    }
    
    func testRetainCycles() {
        let bundle = Bundle(for: type(of: self))
        let fileNames = ["ActivityUpdate", "ActionSetSample", "ImageGallery", "Agenda"]
        let jsons = fileNames.map { NSDataAsset(name: $0 + ".json", bundle: bundle)!.data }
                        .map { String(data: $0, encoding: .utf8)! }
        
        let hostConfigData = NSDataAsset(name: "HostConfig.json", bundle: bundle)!.data
        let hostConfigJSON = String(data: hostConfigData, encoding: .utf8)!
        
        let hostConfig = try! AdaptiveCard.parseHostConfig(from: hostConfigJSON).get()
        let cards = jsons.map { AdaptiveCard.from(jsonString: $0).getAdaptiveCard()! }
        
        weak var weakCard1: NSView?
        weak var weakCard2: NSView?
        weak var weakCard3: NSView?
        weak var weakCard4: NSView?
        
        var blockExecuted = false
        autoreleasepool {
            let card1 = AdaptiveCard.render(card: cards[0], with: hostConfig, width: 432, actionDelegate: delegate, resourceResolver: resourceResolver)
            let card2 = AdaptiveCard.render(card: cards[1], with: hostConfig, width: 432, actionDelegate: delegate, resourceResolver: resourceResolver)
            let card3 = AdaptiveCard.render(card: cards[2], with: hostConfig, width: 432, actionDelegate: delegate, resourceResolver: resourceResolver)
            let card4 = AdaptiveCard.render(card: cards[3], with: hostConfig, width: 432, actionDelegate: delegate, resourceResolver: resourceResolver)
            
            // Simulate show card action
            guard let showCardButton = card1.buttonInHierachy(withTitle: "Set due date") else {
                XCTFail()
                return
            }
            showCardButton.performClick()
            
            weakCard1 = card1
            weakCard2 = card2
            weakCard3 = card3
            weakCard4 = card4
            
            XCTAssertNotNil(weakCard1)
            XCTAssertNotNil(weakCard2)
            XCTAssertNotNil(weakCard3)
            XCTAssertNotNil(weakCard4)
            
            blockExecuted = true
        }
        
        XCTAssertTrue(blockExecuted)
        XCTAssertNil(weakCard1)
        XCTAssertNil(weakCard2)
        XCTAssertNil(weakCard3)
        XCTAssertNil(weakCard4)
    }
    
    func testChildToParentToggleVisibility() {
        let bundle = Bundle(for: type(of: self))
        let filename = "ToggleVisibilityChildToParent.json"
        
        let dataAsset = NSDataAsset(name: filename, bundle: bundle)?.data
        guard let data = dataAsset else { return }
        let jsonString = String(data: data, encoding: .utf8)!
        
        let hostConfigData = NSDataAsset(name: "HostConfig.json", bundle: bundle)!.data
        let hostConfigJSON = String(data: hostConfigData, encoding: .utf8)!
        let hostConfig = try! AdaptiveCard.parseHostConfig(from: hostConfigJSON).get()
        
        let card = AdaptiveCard.from(jsonString: jsonString).getAdaptiveCard()!
        
        let cardView = AdaptiveCard.render(card: card, with: hostConfig, width: 432, actionDelegate: delegate, resourceResolver: resourceResolver)
        
        // get the show card button to show child card view
        guard let showCardButton = cardView.buttonInHierachy(withTitle: "Showcard1") else {
            XCTFail()
            return
        }
        showCardButton.performClick()
        
        // get toggle button from parent
        guard let columnParentButton = cardView.buttonInHierachy(withTitle: "Column Parent") else {
            XCTFail()
            return
        }
        
        // get toggle button from child
        guard let columnChildButton = cardView.buttonInHierachy(withTitle: "Column Child1") else {
            XCTFail()
            return
        }
        
        // on initial render column1 is visible
        guard let column1View = cardView.getView(with: "column1", in: cardView) else { return }
        XCTAssertFalse(column1View.isHidden)
                
        // now on parent toggle button click , column1 becomes hidden
        columnParentButton.performClick()
        XCTAssertTrue(column1View.isHidden)
        
        // now on child toggle button click , column1 becomes visible again
        columnChildButton.performClick()
        XCTAssertFalse(column1View.isHidden)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testRetainCycles()
        }
    }
}
