//
//  FakeImageset.swift
//  AdaptiveCardsTests
//
//  Created by mukuagar on 06/12/22.
//

import AdaptiveCards_bridge

class FakeImageSet: ACSImageSet {
    public var imageSize: ACSImageSize = .auto
    public var height: ACSHeightType = .auto
    public var separator: Bool = false
    public var id: String? = ""
    public var visibility: Bool = true
    public var spacing: ACSSpacing = .default
    public var imageArray: [FakeImage] = []
    
    override func getImageSize() -> ACSImageSize {
        return imageSize
    }
    
    override func setImageSize(_ value: ACSImageSize) {
        imageSize = value
    }
    
    override func getImages() -> [ACSImage] {
        return imageArray
    }
    
    override func setHeight(_ value: ACSHeightType) {
        height = value
    }
    
    override func getHeight() -> ACSHeightType {
        return height
    }
    
    override func getType() -> ACSCardElementType {
        return .imageSet
    }
    
    override func setId(_ value: String) {
        id = value
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func getIsVisible() -> Bool {
        return visibility
    }
    
    override func setIsVisible(_ value: Bool) {
        visibility = value
    }
    
    override func getSeparator() -> Bool {
        return separator
    }
    
    override func setSeparator(_ value: Bool) {
        separator = value
    }
    
    override func getSpacing() -> ACSSpacing {
        return spacing
    }
    
    override func setSpacing(_ value: ACSSpacing) {
        spacing = value
    }
}

extension FakeImageSet {
    static func make(imageSize: ACSImageSize = .medium, images: [FakeImage] = [], height: ACSHeightType = .auto, id: String? = "", separator: Bool = false, visibility: Bool = true, spacing: ACSSpacing = .default) -> FakeImageSet {
        let fakeImageSet = FakeImageSet()
        fakeImageSet.imageSize = imageSize
        fakeImageSet.imageArray = images
        fakeImageSet.height = height
        fakeImageSet.id = id
        fakeImageSet.separator = separator
        fakeImageSet.visibility = visibility
        fakeImageSet.spacing = spacing
        return fakeImageSet
    }
}
