//
//  ACSCollectionViewAlignLayout.swift
//  AdaptiveCards
//
//  Created by uchauhan on 29/11/22.
//

// ******************************************************************
// This class design for CollectionViewFlowLayout
// ******************************************************************

import AdaptiveCards_bridge
import AppKit

typealias ACSCollectionViewDelegateFlowLayout = NSCollectionViewDelegateFlowLayout
let ACSCollectionElementCategoryItemCell = NSCollectionElementCategory.item
typealias ACSCollectionView = NSCollectionView
typealias ACSCollectionViewLayoutAttributes = NSCollectionViewLayoutAttributes
typealias ACSEdgeInsets = NSEdgeInsets
typealias ACSCollectionViewScrollDirection = NSCollectionView.ScrollDirection
typealias ACSCollectionViewFlowLayout = NSCollectionViewFlowLayout

enum ACSCollectionViewItemsHorizontalAlignment: Int {
    case left
    case right
}
enum ACSCollectionViewItemsVerticalAlignment: Int {
    case center
    case top
}
enum ACSCollectionViewItemsDirection: Int {
    case LTR
    case RTL
}

protocol ACSCollectionViewAlignLayoutDelegate: AnyObject, ACSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: ACSCollectionView, layout: ACSCollectionViewAlignLayout, itemsDirectionInSection section: Int) -> ACSCollectionViewItemsDirection
    func collectionView(_ collectionView: ACSCollectionView, layout: ACSCollectionViewAlignLayout, itemsVerticalAlignmentInSection section: Int) -> ACSCollectionViewItemsVerticalAlignment
    func collectionView(_ collectionView: ACSCollectionView, layout: ACSCollectionViewAlignLayout, itemsHorizontalAlignmentInSection section: Int) -> ACSCollectionViewItemsHorizontalAlignment
}

class ACSCollectionViewAlignLayout: ACSCollectionViewFlowLayout {
    var itemsHorizontalAlignment: ACSCollectionViewItemsHorizontalAlignment = .left
    var itemsVerticalAlignment: ACSCollectionViewItemsVerticalAlignment = .top
    var itemsDirection: ACSCollectionViewItemsDirection = .LTR
    private var cachedFrame: [IndexPath: CGRect] = [:]
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes = originalAttributes
        for attributes in originalAttributes {
            if attributes.representedElementKind == nil || attributes.representedElementCategory == ACSCollectionElementCategoryItemCell {
                if let index = updatedAttributes.firstIndex(of: attributes), let attrsIndex = attributes.indexPath, let attr = self.layoutAttributesForItem(at: attrsIndex) {
                    updatedAttributes[index] = attr
                }
            }
        }
        return updatedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        // This is likely occurring because the flow layout subclass ACSCollectionViewAlignLayout is modifying attributes returned by NSCollectionViewFlowLayout without copying them
        let currentAttributes = super.layoutAttributesForItem(at: indexPath)
        // Get the item frame value of the cached current indexPath
        var frameValue = self.getCachedItemFrame(at: indexPath)
        // If there is no cached item frame value, calculate and cache and get
        if frameValue == nil {
            // Determine if it is the first in a row
            let isLineStart = self.isCollectionViewNewLineStart(at: indexPath)
            // if it is the first in a row
            if isLineStart {
                // Get all NSCollectionViewLayoutAttributes of the current row
                let line = lineAttributesArray(withStart: currentAttributes)
                // Calculate and cache all NSCollectionViewLayoutAttributes frames for the current row
                calculateAndCacheFrame(forItemAttributesArray: line)
            }
            // Get the item frame at the current indexPath
            frameValue = self.getCachedItemFrame(at: indexPath)
        }
        if let frameValue = frameValue {
            currentAttributes?.frame = frameValue
        }
        return currentAttributes
    }
}
extension ACSCollectionViewAlignLayout {
    private func minimumInteritemSpacingForSection(at section: Int?) -> CGFloat {
        if let section = section, let collectionView = self.collectionView, let delegate = collectionView.delegate as? ACSCollectionViewAlignLayoutDelegate {
            return delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? .zero
        } else {
            return self.minimumInteritemSpacing
        }
    }
    
    private func insetForSectionAtIndex(at section: Int?) -> ACSEdgeInsets {
        if let section = section, let collectionView = self.collectionView, let delegate = collectionView.delegate as? ACSCollectionViewAlignLayoutDelegate {
            return delegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? NSEdgeInsetsZero
        } else {
            return self.sectionInset
        }
    }
    
    private func itemsHorizontalAlignmentForSectionAtIndex(at section: Int?) -> ACSCollectionViewItemsHorizontalAlignment {
        if let section = section, let collectionView = self.collectionView, let delegate = collectionView.delegate as? ACSCollectionViewAlignLayoutDelegate {
            return delegate.collectionView(collectionView, layout: self, itemsHorizontalAlignmentInSection: section)
        } else {
            return self.itemsHorizontalAlignment
        }
    }
    
    private func itemsVerticalAlignmentForSectionAtIndex(at section: Int?) -> ACSCollectionViewItemsVerticalAlignment {
        if let section = section, let collectionView = self.collectionView, let delegate = collectionView.delegate as? ACSCollectionViewAlignLayoutDelegate {
            return delegate.collectionView(collectionView, layout: self, itemsVerticalAlignmentInSection: section)
        } else {
            return self.itemsVerticalAlignment
        }
    }
    
    private func itemsDirectionForSectionAtIndex(at section: Int?) -> ACSCollectionViewItemsDirection {
        if let section = section, let collectionView = self.collectionView, let delegate = collectionView.delegate as? ACSCollectionViewAlignLayoutDelegate {
            return delegate.collectionView(collectionView, layout: self, itemsDirectionInSection: section)
        } else {
            return self.itemsDirection
        }
    }
}
extension ACSCollectionViewAlignLayout {
    private func isCollectionViewNewLineStart(at indexPath: IndexPath) -> Bool {
        if indexPath.item == 0 {
            return true
        }
        guard indexPath.item > 0 else {
            return false
        }
        let currentIndexPath = indexPath
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        
        let currentAttributes = super.layoutAttributesForItem(at: currentIndexPath)
        let previousAttributes = super.layoutAttributesForItem(at: previousIndexPath)
        let currentFrame = currentAttributes?.frame ?? .zero
        let previousFrame = previousAttributes?.frame ?? .zero
        
        let insets = insetForSectionAtIndex(at: currentIndexPath.section)
        let currentLineFrame = CGRect(x: insets.left, y: currentFrame.origin.y, width: self.collectionView?.frame.width ?? .zero, height: currentFrame.size.height)
        let previousLineFrame = CGRect(x: insets.left, y: previousFrame.origin.y, width: self.collectionView?.frame.width ?? .zero, height: previousFrame.size.height)
        
        return !currentLineFrame.intersects(previousLineFrame)
    }
    
    private func lineAttributesArray(withStart startAttributes: ACSCollectionViewLayoutAttributes?) -> [ACSCollectionViewLayoutAttributes]? {
        var lineAttributesArray: [ACSCollectionViewLayoutAttributes] = []
        if let startAttributes = startAttributes {
            lineAttributesArray.append(startAttributes)
            guard let collectionView = self.collectionView else {
                return nil
            }
            let itemCount = collectionView.numberOfItems(inSection: startAttributes.indexPath?.section ?? 0)
            let insets = insetForSectionAtIndex(at: startAttributes.indexPath?.section)
            var index = startAttributes.indexPath?.item ?? 0
            
            var isLineEnd = false
            while !isLineEnd {
                index += 1
                if index == itemCount {
                    break
                }
                let nextIndexPath = IndexPath(item: index, section: startAttributes.indexPath?.section ?? 0)
                let nextAttributes = super.layoutAttributesForItem(at: nextIndexPath)
                let nextLineFrame = CGRect(x: insets.left, y: nextAttributes?.frame.origin.y ?? .zero, width: collectionView.frame.width, height: nextAttributes?.frame.size.height ?? .zero)
                isLineEnd = !startAttributes.frame.intersects(nextLineFrame)
                if isLineEnd {
                    break
                }
                if let nextAttributes = nextAttributes {
                    lineAttributesArray.append(nextAttributes)
                }
            }
            return lineAttributesArray
        }
        return nil
    }
}
extension ACSCollectionViewAlignLayout {
    private func setCacheItemFrame(_ frame: CGRect, for indexPath: IndexPath?) {
        if let indexPath = indexPath {
            self.cachedFrame[indexPath] = frame
        }
    }
    
    private func getCachedItemFrame(at indexPath: IndexPath?) -> CGRect? {
        if let indexPath = indexPath {
            return self.cachedFrame[indexPath]
        }
        return nil
    }
    
    private func calculateAndCacheFrame(forItemAttributesArray attributes: [ACSCollectionViewLayoutAttributes]?) {
        if let attributes = attributes, let collectionView = self.collectionView {
            let section = attributes.first?.indexPath?.section ?? 0
            let horizontalAlignment = itemsHorizontalAlignmentForSectionAtIndex(at: section)
            let verticalAlignment = itemsVerticalAlignmentForSectionAtIndex(at: section)
            let direction = itemsDirectionForSectionAtIndex(at: section)
            let sectionInsets = insetForSectionAtIndex(at: section)
            let minimumInteritemSpacing = minimumInteritemSpacingForSection(at: section)
            let contentInsets: ACSEdgeInsets = NSEdgeInsetsZero

            let collectionViewWidth = collectionView.frame.width
            let widthArray = attributes.map({ $0.frame.width })
            let totalWidth = widthArray.reduce(0, +)
            let totalCount = attributes.count

            // ******************** Vertical position (origin.y), used for vertical alignment calculations ******************** //
            var tempOriginY: CGFloat = 0.0
            let frameValues: [NSRect] = attributes.map({ $0.frame })
            if verticalAlignment == .top {
                tempOriginY = CGFloat.greatestFiniteMagnitude
                for frameValue in frameValues {
                    tempOriginY = CGFloat(min(tempOriginY, frameValue.minY))
                }
            }

            // ******************** Calculate starting point and distance ******************** //

            var start: CGFloat = 0.0
            var space: CGFloat = 0.0
            switch horizontalAlignment {
            case .left:
                start = sectionInsets.left
                space = minimumInteritemSpacing
                start = direction == .RTL ? (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - (minimumInteritemSpacing * CGFloat(totalCount - 1))) : sectionInsets.left
                space = minimumInteritemSpacing
            case .right:
                start = direction == .RTL ? sectionInsets.right : (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.right - minimumInteritemSpacing * CGFloat(totalCount - 1))
                space = minimumInteritemSpacing
            }

            // ******************** Compute and cache frame ******************** //

            var lastMaxX: CGFloat = .zero
            for index in 0..<widthArray.count {
                var frame = attributes[index].frame
                let width = widthArray[index]
                var originX: CGFloat = 0.0
                if direction == .RTL {
                    originX = index == 0 ? collectionViewWidth - start - contentInsets.right - contentInsets.left - width : lastMaxX - space - width
                    lastMaxX = originX
                } else {
                    originX = index == 0 ? start : lastMaxX + space
                    lastMaxX = originX + width
                }
                var originY: CGFloat
                if verticalAlignment == .center {
                    originY = frame.origin.y
                } else {
                    originY = tempOriginY
                }
                frame.origin.x = originX
                frame.origin.y = originY
                frame.size.width = width
                setCacheItemFrame(frame, for: attributes[index].indexPath)
            }
        }
    }
}
