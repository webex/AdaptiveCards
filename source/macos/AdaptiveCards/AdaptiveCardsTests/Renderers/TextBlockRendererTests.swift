@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class TextBlockRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var textBlock: FakeTextBlock!
    private var textBlockRenderer: TextBlockRenderer!
    private var resourceResolver: FakeResourceResolver!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        textBlock = .make()
        textBlockRenderer = TextBlockRenderer()
        resourceResolver = FakeResourceResolver()
    }
    
    func testHeightProperty() {
        textBlock = FakeTextBlock.make(text: "Test auto Height Property", heightType: .auto)
        let autoTextView = renderTextView()
        XCTAssertEqual(autoTextView.contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultHigh)
        textBlock = FakeTextBlock.make(text: "Test stretch Height Property", heightType: .stretch)
        let stretchTextView = renderTextView()
        XCTAssertEqual(stretchTextView.contentHuggingPriority(for: .vertical), NSLayoutConstraint.Priority.defaultLow)
    }
    
    func testRendererSetsText() {
        let text = "Hello world!"
        textBlock = .make(text: text)
        
        let textView = renderTextView()
        XCTAssertEqual(textView.string, text)
    }
    
    func testRendererSetsMarkdownText() {
        let markdownText = "**Hello** _world!_"
        textBlock = .make(text: markdownText)
        
        let textView = renderTextView()
        XCTAssertEqual(textView.string, "Hello world!")
        XCTAssertTrue(resourceResolver.textResolverCalled)
    }
    
    func testRendererSetsMultiTraitMarkdownText() {
        var markdownText = "_Hello world!_"
        textBlock = .make(text: markdownText, textWeight: .bolder)
        var textView = renderTextView()
        
        XCTAssertEqual(textView.string, "Hello world!")
        XCTAssertEqual("CTFontBoldItalicUsage", (textView.attributedString().attributes(at: 0, effectiveRange: nil)[.font] as! NSFont).fontDescriptor.fontAttributes[.init("NSCTFontUIUsageAttribute")] as! String)
        
        markdownText = "**Hello world!**"
        textBlock = .make(text: markdownText, textWeight: .lighter)
        textView = renderTextView()
        XCTAssertEqual(textView.string, "Hello world!")
        XCTAssertEqual("CTFontBoldUsage", (textView.attributedString().attributes(at: 0, effectiveRange: nil)[.font] as! NSFont).fontDescriptor.fontAttributes[.init("NSCTFontUIUsageAttribute")] as! String)
        
        markdownText = "*Hello world!**"
        textBlock = .make(text: markdownText, textWeight: .lighter)
        textView = renderTextView()
        XCTAssertEqual(textView.string, "Hello world!*")
        XCTAssertEqual("CTFontObliqueUsage", (textView.attributedString().attributes(at: 0, effectiveRange: nil)[.font] as! NSFont).fontDescriptor.fontAttributes[.init("NSCTFontUIUsageAttribute")] as! String)
        
        markdownText = "This is the _test_ for [Webex](https://www.webex.com)"
        textBlock = .make(text: markdownText, textWeight: .bolder)
        textView = renderTextView()
        XCTAssertEqual(textView.string, "This is the test for Webex")
        XCTAssertEqual("CTFontBoldUsage", (textView.attributedString().attributes(at: 0, effectiveRange: nil)[.font] as! NSFont).fontDescriptor.fontAttributes[.init("NSCTFontUIUsageAttribute")] as! String)
        XCTAssertEqual("CTFontBoldItalicUsage", (textView.attributedString().attributes(at: 14, effectiveRange: nil)[.font] as! NSFont).fontDescriptor.fontAttributes[.init("NSCTFontUIUsageAttribute")] as! String)
        
        // This Case currently Not supported
        /**markdownText = "**_Hello world!_**"
        textBlock = .make(text: markdownText, textWeight: .lighter)
        textView = renderTextView()
        XCTAssertEqual(textView.string, "Hello world!")
        XCTAssertEqual("CTFontBoldUsage", (textView.attributedString().attributes(at: 0, effectiveRange: nil)[.font] as! NSFont).fontDescriptor.fontAttributes[.init("NSCTFontUIUsageAttribute")] as! String)*/
        
        XCTAssertTrue(resourceResolver.textResolverCalled)
    }
    
    func testRendererSetsWrap() {
        textBlock = .make(wrap: true)
        
        let textView = renderTextView()
        XCTAssertEqual(textView.textContainer?.maximumNumberOfLines ?? -1, 0)
        
        textBlock = .make(wrap: false)
        let textView2 = renderTextView()
        XCTAssertEqual(textView2.textContainer?.maximumNumberOfLines ?? -1, 1)
    }
    
    func testRendererSetsMaxLines() {
        textBlock = .make(wrap: true, maxLines: 2)
        let textView = renderTextView()
        XCTAssertEqual(textView.textContainer?.maximumNumberOfLines ?? -1, 2)
    }
    
    func testRendererSetsMaxLines_wrapFalse() {
        textBlock = .make(wrap: false, maxLines: 2)
        let textView = renderTextView()
        XCTAssertEqual(textView.textContainer?.maximumNumberOfLines ?? -1, 1)
    }
    
    func testRendererSetsHorizontalAlignment() {
        textBlock = .make(text: "Hello world!", horizontalAlignment: .right)
        var textView = renderTextView()
        var attributedString = textView.attributedString()
        guard let paragraphStyle = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle else { return XCTFail() }
        XCTAssertEqual(paragraphStyle.alignment, .right)
        
        textBlock = .make(text: "Hello world!", horizontalAlignment: .center)
        textView = renderTextView()
        attributedString = textView.attributedString()
        guard let paragraphStyle2 = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle else { return XCTFail() }
        XCTAssertEqual(paragraphStyle2.alignment, .center)
    }
    
    func testRendererSetsRequiredProperties() {
        let textView = renderTextView()
        
        XCTAssertFalse(textView.isEditable) // Should be disbled
        XCTAssertEqual(textView.textContainerInset, .zero)
        XCTAssertTrue(textView.textContainer?.widthTracksTextView ?? false) // Needed for wrapping text
        XCTAssertEqual(textView.backgroundColor, .clear)
    }
    
    func testListedIndent() {
        textBlock = .make(text: "1. Open the Cisco AnyConnect Secure Mobility Client from your Applications folder.")
        let textView = renderTextView()
        let attributedString = textView.attributedString()
        guard let paragraphStyle2 = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle else { return XCTFail() }
        XCTAssertEqual(paragraphStyle2.headIndent, 56)
        XCTAssertEqual(textView.string, "\t1\tOpen the Cisco AnyConnect Secure Mobility Client from your Applications folder.")
    }
    
    func testHyperLinkTextInTextView() {
        textBlock = .make(text: "This is the first inline. We **do** _support_ [makrdown](https://www.google.com/).")
        var textView = renderTextView()
        XCTAssertTrue(textView.hasLinks)
        XCTAssertTrue(textView.acceptsFirstResponder)
        XCTAssertTrue(textView.canBecomeKeyView)
        
        textBlock = .make(text: "This is the first inline. We **do** _support_.")
        textView = renderTextView()
        XCTAssertFalse(textView.hasLinks)
        XCTAssertFalse(textView.acceptsFirstResponder)
        XCTAssertFalse(textView.canBecomeKeyView)
    }
    
    private func renderTextView() -> ACRTextView {
        let rootView = FakeRootView()
        rootView.resolverDelegate = resourceResolver
        let view = textBlockRenderer.render(element: textBlock, with: hostConfig, style: .default, rootView: rootView, parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRTextView)
        guard let textView = view as? ACRTextView else { fatalError() }
        return textView
    }
}
