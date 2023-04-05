//
//  ACRCollectionViewTests.swift
//  AdaptiveCardsTests
//
//  Created by mukuagar on 06/12/22.
//

@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest


class ACRCollectionViewTests: XCTestCase {
    var collectionView: ACRCollectionView!
    var collectionViewLayout: ACSCollectionViewAlignLayout!
    private var hostConfig: FakeHostConfig!
    private var rootView: FakeRootView!
    private var parentView: NSView!
    private var imageSet: FakeImageSet!
    
    override func setUp() {
        super.setUp()
        rootView = FakeRootView()
        parentView = NSView(frame: .zero)
        imageSet = FakeImageSet.make()
        let imageSizesConfig = ACSImageSizesConfig(smallSize: 100, mediumSize: 200, largeSize: 300)
        hostConfig = FakeHostConfig.make(imageSizes: imageSizesConfig)
        collectionViewLayout = ACSCollectionViewAlignLayout()
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: imageSet, hostConfig: hostConfig, collectionLayout: collectionViewLayout)
    }
    
    func testCollectionViewRenderEmptyImageArray() {
        XCTAssertEqual(collectionView.collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.collectionView.numberOfItems(inSection: 0), 0)
    }
    
    func testCollectionViewRendersNElements() {
        let n = Int.random(in: 1..<100)
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .small, images: generateImageArray(ofSize: n, imageWidth: 0, imageHeight: 0)), hostConfig: hostConfig, collectionLayout: collectionViewLayout)
        XCTAssertEqual(collectionView.collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.collectionView.numberOfItems(inSection: 0), n)
    }
    
    func testImageSetDefaultSize() {
        // If imageset size not given, default size is medium
        let image = FakeImage.make()
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(images: [image]), hostConfig: hostConfig)
        
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)), NSSize(width: 208, height: 208))
        
    }
    
    func testImageSetSizePriority() {
        // If both image and imageset have size, priority is always imageset size
        let image = FakeImage.make(imageSize: .small)
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: [image]), hostConfig: hostConfig, collectionLayout: collectionViewLayout)
        // We respect image size of imageset even if image size is present
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)), NSSize(width: 308, height: 308))
    }
    
    func testCollectionViewImageExplicitHeight() {
        let image = FakeImage.make(pixelHeight: 120)
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: [image]), hostConfig: hostConfig, collectionLayout: collectionViewLayout)
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)), NSSize(width: 128, height: 128))
    }
    
    func testCollectionViewImageExplicitWidth() {
        // if explicit width less than collection view width, we can make the cell as big as explicit width
        let image = FakeImage.make(pixelWidth: 140)
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: [image]), hostConfig: hostConfig, collectionLayout: collectionViewLayout)
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)), NSSize(width: 148, height: 148))
    }
    
    func testCollectionViewImageExplicitWidthAndHeight() {
        let image = FakeImage.make(pixelWidth:140, pixelHeight: 120)
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: [image]), hostConfig: hostConfig, collectionLayout: collectionViewLayout, frameRect: NSRect(origin: .zero, size: NSSize(width: 500, height: 500)))
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)), NSSize(width: 148, height: 128))
    }
    
    func testCollectionViewItemSizeNotExcedeParentWidth() {
        let image = FakeImage.make(pixelWidth:140, pixelHeight: 120)
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: [image]), hostConfig: hostConfig, collectionLayout: collectionViewLayout, frameRect: NSRect(origin: .zero, size: NSSize(width: 50, height: 500)))
        // Width will be the width of collectionView since explicit width greater than collection view width
        XCTAssertEqual(collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)), NSSize(width: 58, height: 128))
    }
    
    func testCollectionViewHeight() {
        let numberOfItems = 3
        let imageDimenion = 100
        let collectionViewWidth = 300
        let imageArray = generateImageArray(ofSize: numberOfItems, imageWidth: imageDimenion, imageHeight: imageDimenion)
        
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: imageArray), hostConfig: hostConfig, collectionLayout: collectionViewLayout, frameRect: NSRect(origin: .zero, size: NSSize(width: collectionViewWidth, height: 500)))
        
        // We have proved that there is only ever one section in collection view in above tests
        let minItemSpacing = collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        
        // minimum item spacing for 3 elements will be width of 3 elements plus 2x min item spacing
        let minRequiredWidth: CGFloat = CGFloat(integerLiteral:numberOfItems * (imageDimenion + 8)) + CGFloat((numberOfItems - 1)) * minItemSpacing
        XCTAssertLessThan(collectionView.collectionView.intrinsicContentSize.width, minRequiredWidth)
        // Now that we know less space is available than required to display in one row, collectionView should layout to multiple rows so height should increase
        let numberOfRows = Int(ceil(minRequiredWidth/CGFloat(collectionViewWidth)))
        let calculatedHeight = CGFloat(numberOfRows * (imageDimenion + 8)) + CGFloat((numberOfRows - 1)) * minItemSpacing
        XCTAssertEqual(collectionView.intrinsicContentSize.height, calculatedHeight)
        collectionView.collectionView.reloadData()
        XCTAssertEqual(collectionView.collectionView.collectionViewLayout, collectionViewLayout)

    }
    
    func testCollectionViewHorizontalSpacingLayout() {
        let numberOfItems = 3
        let imageDimenion = 100
        let collectionViewWidth = 300
        let imageArray = generateImageArray(ofSize: numberOfItems, imageWidth: imageDimenion, imageHeight: imageDimenion)
        
        collectionView = ACRCollectionView(rootView: rootView, parentView: parentView, imageSet: FakeImageSet.make(imageSize: .large, images: imageArray), hostConfig: hostConfig, collectionLayout: collectionViewLayout, frameRect: NSRect(origin: .zero, size: NSSize(width: collectionViewWidth, height: 500)))
        
        // We have proved that there is only ever one section in collection view in above tests
        let minItemSpacing = collectionView.collectionView(collectionView.collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        
        // minimum item spacing for 3 elements will be width of 3 elements plus 2x min item spacing
        let minRequiredWidth: CGFloat = CGFloat(integerLiteral:numberOfItems * imageDimenion) + CGFloat((numberOfItems - 1)) * minItemSpacing
        XCTAssertLessThan(collectionView.collectionView.intrinsicContentSize.width, minRequiredWidth)
        collectionView.display()
        // Now we know that there are 2 elements, we should check if they are framed correctly accoring to calculations
        let firstElementFrame = collectionView.collectionView.frameForItem(at: 0)
        let secondElementFrame = collectionView.collectionView.frameForItem(at: 1)
        let thirdElementFrame = collectionView.collectionView.frameForItem(at: 2)
        
        // FirstElement should be present at the top left of frame
        let firstElementCalculatedFrame = NSRect(x: 0, y: 0, width: (imageDimenion + 8), height: (imageDimenion + 8))
        
        // second element will be layout after firstElement with a space of minItemSpacing
        let secondElementCalculatedFrame = NSRect(x: (imageDimenion + 8) + Int(minItemSpacing), y: 0, width: (imageDimenion + 8), height: (imageDimenion + 8))
        
        // third element will be layout in second row as no space in first, so there will be a shift in y by imageHeight and minItemSpacing
        let thirdElementCalculatedFrame = NSRect(x: 0, y: (imageDimenion + 8) + Int(minItemSpacing), width: (imageDimenion + 8), height: (imageDimenion + 8))
        
        XCTAssertEqual(firstElementFrame, firstElementCalculatedFrame)
        XCTAssertEqual(secondElementFrame, secondElementCalculatedFrame)
        XCTAssertEqual(thirdElementFrame, thirdElementCalculatedFrame)
    }
    
    private func generateImageArray(ofSize number: Int, imageWidth: Int, imageHeight: Int) -> [FakeImage] {
        var imageArray: [FakeImage] = []
        for _ in 0..<number {
            imageArray.append(FakeImage.make(pixelWidth: NSNumber(integerLiteral: imageWidth), pixelHeight: NSNumber(integerLiteral: imageHeight)))
        }
        return imageArray
    }
}
