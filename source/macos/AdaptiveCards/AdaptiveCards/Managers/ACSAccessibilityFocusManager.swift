//
//  ACSAccessibilityFocusManager.swift
//  AdaptiveCards
//
//  Created by uchauhan on 31/05/23.
//
//  This class is designed to handle the nextKeyView in adaptive card navigation accessibility of views.

import AdaptiveCards_bridge
import AppKit

// Protocol for views that can be navigated using the nextKeyView
protocol AccessibleFocusView: AnyObject {
    /// The view to exit focus to
    /// `exitView` represents the view that should refer the focus view when the current view needs to exit focus. It's a reference to another view that must conforms to the `AccessibleFocusView` protocol.
    var exitView: AccessibleFocusView? { get set }
    
    /// The valid key view for the focus
    /// `validKeyView` returns the valid key view that should receive the focus. It's a reference to an NSView that is considered a valid key view for the focus.
    var validKeyView: NSView? { get }
    
    /// Setup internal key views for focus management
    /// Method is responsible for setting up the internal key views within the view that adopts the `AccessibleFocusView` protocol. It allows the view to configure its internal key views for proper focus management
    func setupInternalKeyviews()
}

// Manager class to handle nextKeyView navigation
class ACSAccessibilityFocusManager {
    /// track accessible view for nextKeyView
    @Weak private var accessibleViews: [NSView]
    
    /// Index pointer for inserting new accessible views
    private var pointerHead = 0
    
    /// get first accessible view for root view
    var entryView: NSView? {
        return accessibleViews.first?.toAccessibleFocusView?.validKeyView
    }
    
    /// get last accessible view for root view
    var exitView: NSView? {
        return accessibleViews.last?.toAccessibleFocusView?.validKeyView
    }
    
    init() {
        accessibleViews = []
    }
    
    /// Register a view to be managed for accessibility focus
    /// - Parameter view: The accessible `NSView` element to register with the accessibility context
    func registerView(_ view: AccessibleFocusView) {
        guard let nsview = view as? NSView else { return }
        accessibleViews.insert(nsview, at: pointerHead)
        pointerHead += 1
    }
    
    /// Set the pointer head at the specified view
    /// - Parameter view: The view to set as the pointer head
    func setPointerHead(to view: NSView) {
        if let index = accessibleViews.firstIndex(of: view) {
            pointerHead = index + 1
        }
    }
    
    /// Set the pointer head at the last registered view
    func setPointerHeadToLast() {
        pointerHead = accessibleViews.count
    }
    
    /// Recalculate the key view loop and set exit views for each view
    func recalculateKeyViewLoop() {
        guard !accessibleViews.isEmpty else { return }
        var previousVisibleView: AccessibleFocusView?
        var firstVisibleView: AccessibleFocusView?
        
        for view in accessibleViews {
            guard let accessibleView = view.toAccessibleFocusView, !view.isHidden else {
                continue
            }
            
            // Set the exit view for the previous visible view
            previousVisibleView?.exitView = accessibleView
            previousVisibleView?.setupInternalKeyviews()
            
            // Track the first visible view
            if firstVisibleView == nil {
                firstVisibleView = accessibleView
            }
            
            previousVisibleView = accessibleView
        }
        
        // Set the exit view for the last visible view
        if let lastVisibleView = previousVisibleView {
            lastVisibleView.exitView = firstVisibleView ?? accessibleViews.first?.toAccessibleFocusView
            lastVisibleView.setupInternalKeyviews()
        }
    }
}

extension NSView {
    var toAccessibleFocusView: AccessibleFocusView? {
        return self as? AccessibleFocusView
    }
}

/// Generic Weak Type Object
final class WeakObject<T: AnyObject> {
    private(set) weak var value: T?
    init(_ value: T) { self.value = value }
}

@propertyWrapper
struct Weak<Element> where Element: AnyObject {
    private var storage = [WeakObject<Element>]()

    var wrappedValue: [Element] {
        get { storage.compactMap { $0.value } }
        set {
            storage = newValue.map { WeakObject($0) }
        }
    }
}
