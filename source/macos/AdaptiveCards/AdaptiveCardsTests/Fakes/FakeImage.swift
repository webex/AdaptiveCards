import AdaptiveCards_bridge

class FakeImage: ACSImage {
    public var url: String?
    public var id: String?
    public var backgroundColor: String?
    public var imageStyle: ACSImageStyle = .default
    public var imageSize: ACSImageSize = .auto
    public var horizontalAlignment: ACSHorizontalAlignment = .left
    public var pixelWidth: NSNumber = 0
    public var pixelHeight: NSNumber = 0
    public var isVisible: Bool = true
    public var selectAction: ACSBaseActionElement?

    override func getUrl() -> String? {
        return url
    }
    
    override func getBackgroundColor() -> String? {
        return backgroundColor
    }
    
    override func getStyle() -> ACSImageStyle {
        return imageStyle
    }
    
    override func getSize() -> ACSImageSize {
        return imageSize
    }
    
    override func getHorizontalAlignment() -> ACSHorizontalAlignment {
        return horizontalAlignment
    }
    
    override func getPixelWidth() -> NSNumber? {
        return pixelWidth
    }
    
    override func getPixelHeight() -> NSNumber? {
        return pixelHeight
    }
    
    override func getIsVisible() -> Bool {
        return isVisible
    }
    
    override func getSelectAction() -> ACSBaseActionElement? {
        return selectAction
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func setId(_ value: String) {
        self.id = value
    }
}

extension FakeImage {
    static func make(url: String? = "sampleUrl", id: String? = "", backgroundColor: String? = "#FFFFFF", imageStyle: ACSImageStyle = .default, imageSize: ACSImageSize = .auto, horizontalAlignment: ACSHorizontalAlignment = .left, pixelWidth: NSNumber = 0, pixelHeight: NSNumber = 0, isVisible: Bool = true, selectAction: ACSBaseActionElement? = nil) -> FakeImage {
        let fakeImageView = FakeImage()
        fakeImageView.url = url
        fakeImageView.id = id
        fakeImageView.backgroundColor = backgroundColor
        fakeImageView.imageStyle = imageStyle
        fakeImageView.imageSize = imageSize
        fakeImageView.horizontalAlignment = horizontalAlignment
        fakeImageView.pixelWidth = pixelWidth
        fakeImageView.pixelHeight = pixelHeight
        fakeImageView.isVisible = isVisible
        fakeImageView.selectAction = selectAction
        return fakeImageView
    }
}
