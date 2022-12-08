//
//  FakeImageset.swift
//  AdaptiveCardsTests
//
//  Created by mukuagar on 06/12/22.
//

import AdaptiveCards_bridge

class FakeImageSet: ACSImageSet {
    public var imageSize: ACSImageSize = .auto
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
}

extension FakeImageSet {
    static func make(imageSize: ACSImageSize = .medium, images: [FakeImage] = []) -> FakeImageSet {
        let fakeImageSet = FakeImageSet()
        fakeImageSet.imageSize = imageSize
        fakeImageSet.imageArray = images
        return fakeImageSet
    }
}
