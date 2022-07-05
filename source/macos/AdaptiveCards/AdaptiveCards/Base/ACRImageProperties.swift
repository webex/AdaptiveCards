import AdaptiveCards_bridge
import AppKit

struct ACRAspectRatio {
    var widthToHeight: CGFloat
    var heightToWidth: CGFloat
}

class ACRImageProperties: NSObject {
    var hasExplicitDimensions = false
    var isAspectRatioNeeded = false
    var contentSize = CGSize.zero
    var acsImageSize = ACSImageSize.auto
    var acsHorizontalAlignment = ACSHorizontalAlignment.left
    var pixelWidth: CGFloat = 0
    var pixelHeight: CGFloat = 0
    
    init(element: ACSBaseCardElement, config: ACSHostConfig, parentView: NSView) {
        super.init()
        guard let imageElement = element as? ACSImage else {
            logError("Element is not of type ACSImage")
            return
        }
        
        pixelWidth = imageElement.getPixelWidth() as? CGFloat ?? 0
        pixelHeight = imageElement.getPixelHeight() as? CGFloat ?? 0
        if pixelWidth > 0 || pixelHeight > 0 {
            hasExplicitDimensions = true
        }
        if hasExplicitDimensions && !(pixelWidth > 0 && pixelHeight > 0) {
            // if either pixel width or pixel height is provided
            isAspectRatioNeeded = true
        }
        
        acsImageSize = imageElement.getSize()
        if acsImageSize == ACSImageSize.none {
            acsImageSize = ACSImageSize.auto
        }
        
        // update the content size based on image sizes and pixel dimensions
        contentSize = ImageUtils.getImageSizeAsCGSize(imageSize: acsImageSize,
                                                      width: pixelWidth,
                                                      height: pixelHeight,
                                                      with: config,
                                                      explicitDimensions: hasExplicitDimensions)
        
        acsHorizontalAlignment = imageElement.getHorizontalAlignment()
    }
    
    func updateContentSize(size: CGSize) {
        let ratios: CGSize = ImageUtils.getAspectRatio(from: size)
        
        let heightToWidthRatio = ratios.height
        let widthToHeightRatio = ratios.width
        var newSize = contentSize
        
        if hasExplicitDimensions {
            if pixelWidth > 0 {
                newSize.width = pixelWidth
                if pixelHeight == 0 {
                    newSize.height = pixelWidth * heightToWidthRatio
                    pixelHeight = newSize.height
                }
            }
            
            if pixelHeight > 0 {
                newSize.height = pixelHeight
                if pixelWidth == 0 {
                    newSize.width = pixelHeight * widthToHeightRatio
                    pixelWidth = newSize.width
                }
            }
            contentSize = newSize
        } else if acsImageSize == ACSImageSize.auto || acsImageSize == ACSImageSize.stretch {
            contentSize = size
        } else if acsImageSize == ACSImageSize.small || acsImageSize == ACSImageSize.medium || acsImageSize == ACSImageSize.large {
            newSize = contentSize
            newSize.height = contentSize.width * heightToWidthRatio
            contentSize = newSize
        }
    }
}

// MARK: - class function
extension ACRImageProperties {
    // Size to Aspect Ratio conversion
    class func convertToAspectRatio(_ cgsize: CGSize) -> ACRAspectRatio {
        if cgsize.width == 0 {
            return .init(widthToHeight: 1.0, heightToWidth: 1.0)
        }
        // keeping all precisions are not necessary, and 744W X 84H and its multiples cause a crash.
        // rounding off to 100th points.
        // To make the constraints work, the rounded value has to become 1 when the two ratios are multiplied
        let precision: CGFloat = 100
        // MAX is necessary to prevent heightByWidth becoming zero.
        let heightToWidth = max(round(precision * (cgsize.height / cgsize.width)) / precision, 1 / precision)
        return .init(widthToHeight: 1 / heightToWidth, heightToWidth: heightToWidth)
    }
}

extension NSImage {
    var absoluteSize: NSSize {
        guard !representations.isEmpty else {
            return size
        }
        let info = representations[0]
        return NSSize(width: info.pixelsWide, height: info.pixelsHigh)
    }
}
