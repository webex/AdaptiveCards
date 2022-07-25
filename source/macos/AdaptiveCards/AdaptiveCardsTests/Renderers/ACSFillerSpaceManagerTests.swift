//
//  ACSFillerSpaceManagerTests.swift
//  AdaptiveCardsTests
//
//  Created by uchauhan on 25/07/22.
//

@testable import AdaptiveCards
import XCTest

class ACSFillerSpaceManagerTests: XCTestCase {
    private var paddingHandler: ACSFillerSpaceManager!
    
    override func setUp() {
        super.setUp()
        paddingHandler = ACSFillerSpaceManager()
        XCTAssertNotNil(paddingHandler)
    }
    
    func testPaddingConfigure() {
        let elem = FakeTextBlock.make(text: "Filler Space Manager Test")
        let paddingView = NSView()
        paddingHandler.configureHeight(view: paddingView, correspondingElement: elem)
        XCTAssertFalse(paddingHandler.hasPadding())
        XCTAssertNotEqual(kFillerViewLayoutConstraintPriority, paddingView.contentHuggingPriority(for: .vertical))
        elem.setHeight(.stretch)
        paddingHandler.configureHeight(view: paddingView, correspondingElement: elem)
        XCTAssertTrue(paddingHandler.hasPadding())
        XCTAssertEqual(kFillerViewLayoutConstraintPriority, paddingView.contentHuggingPriority(for: .vertical))
        XCTAssertFalse(paddingHandler.isPadding(paddingView))
    }
    
    func testPaddingConstraintActivate() {
        let textBlocks = buildStretchTextBlock(count: 3)
        let superView = NSView()
        for textBlock in textBlocks {
            let view = NSView()
            superView.addSubview(view)
            paddingHandler.configureHeight(view: view, correspondingElement: textBlock)
            XCTAssertFalse(paddingHandler.isPadding(view))
            XCTAssertEqual(kFillerViewLayoutConstraintPriority, view.contentHuggingPriority(for: .vertical))
        }
        let activeConstraints = paddingHandler.activateConstraintsForPadding()
        XCTAssertNotNil(activeConstraints)
        XCTAssertEqual(activeConstraints?.count, 2)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func buildStretchTextBlock(count: Int) -> [FakeTextBlock] {
        var textBlocks = [FakeTextBlock]()
        for i in 0..<count {
            let elem = FakeTextBlock.make(text: "Filler Space Manager Test \(i + 1)")
            elem.setHeight(.stretch)
            textBlocks.append(elem)
        }
        return textBlocks
    }
}
