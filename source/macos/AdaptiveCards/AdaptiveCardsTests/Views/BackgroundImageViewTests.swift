@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ViewTests: XCTestCase {
    var imageView: ACRBackgroundImageView!
    
    override func setUp() {
        super.setUp()
        imageView = ACRBackgroundImageView()
    }
    
    // Test Cases are named as testBGImage<fillmode><horizontalAlignment><verticalAlignment>
    
    func testBGImageCoverLeftTop() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageCoverLeftBottom() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageCoverLeftCenter() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageCoverRightTop() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageCoverRightBottom() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageCoverRightCenter() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageCoverCenterTop() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageCoverCenterBottom() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageCoverCenterCenter() {
        imageView.fillMode = .cover
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRpthorizontallyLeftTop() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRpthorizontallyLeftBottom() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRpthorizontallyLeftCenter() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRpthorizontallyRightTop() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRpthorizontallyRightBottom() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRpthorizontallyRightCenter() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRpthorizontallyCenterTop() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRpthorizontallyCenterBottom() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRpthorizontallyCenterCenter() {
        imageView.fillMode = .repeatHorizontally
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRptverticallyLeftTop() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRptverticallyLeftBottom() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRptverticallyLeftCenter() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRptverticallyRightTop() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRptverticallyRightBottom() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRptverticallyRightCenter() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRptverticallyCenterTop() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRptverticallyCenterBottom() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRptverticallyCenterCenter() {
        imageView.fillMode = .repeatVertically
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRepeatLeftTop() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRepeatLeftBottom() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRepeatLeftCenter() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .left
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = CGFloat(0)
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.minX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRepeatRightTop() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRepeatRightBottom() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRepeatRightCenter() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .right
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.bounds.maxX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.maxX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    func testBGImageRepeatCenterTop() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .top
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = CGFloat(0)
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.minY, yOrigin)
    }
    
    func testBGImageRepeatCenterBottom() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .bottom
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.bounds.maxY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.maxY, yOrigin)
    }
    
    func testBGImageRepeatCenterCenter() {
        imageView.fillMode = .repeat
        imageView.horizontalAlignment = .center
        imageView.verticalAlignment = .center
        imageView.bgimage = getImageFile()
        let imageLayer = getImageLayer()
        let xOrigin = imageView.layer?.frame.midX
        let yOrigin = imageView.layer?.frame.midY
        XCTAssertEqual(imageLayer.frame.midX, xOrigin)
        XCTAssertEqual(imageLayer.frame.midY, yOrigin)
    }
    
    
    private func getImageFile() -> NSImage {
        guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards"),
              let path = bundle.path(forResource: "cisco", ofType: "jpg") else {
            logError("Image Not Found")
            return NSImage()
        }
        let image = NSImage(byReferencing: URL(fileURLWithPath: path))
        return image
    }
    
    private func getImageLayer() -> CALayer {
        guard let imageLayer = imageView.layer?.sublayers?.first else { fatalError() }
        return imageLayer
    }
}
