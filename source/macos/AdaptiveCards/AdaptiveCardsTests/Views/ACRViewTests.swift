@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRViewTests: XCTestCase {
    private var view: ACRView!
    private var fakeResourceResolver: FakeResourceResolver!
    private var actionDelegate: FakeAdaptiveCardActionDelegate!
    private var config: RenderConfig!
    
    override func setUp() {
        super.setUp()
        view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: .default, visibilityContext: ACOVisibilityContext(), accessibilityContext: ACSAccessibilityFocusManager())
        fakeResourceResolver = FakeResourceResolver()
        actionDelegate = FakeAdaptiveCardActionDelegate()
        
        config = RenderConfig.default
        view.resolverDelegate = fakeResourceResolver
        view.delegate = actionDelegate
    }
    
    func testACRViewInitsWithoutError() {
        //Test default initialsier
        let acrView = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: .default)
        XCTAssertNotNil(acrView)
    }
    
    func testRegisterImageHandlingView() {
        let imageView1 = FakeImageHoldingView()
        let imageView2 = FakeImageHoldingView()
        
        view.registerImageHandlingView(imageView1, for: "test1")
        view.registerImageHandlingView(imageView2, for: "test2")
        
        XCTAssertEqual(view.imageViewMap["test1"]![0], imageView1)
        XCTAssertEqual(view.imageViewMap["test2"]![0], imageView2)
    }
    
    func testResourceResolver() {
        let imageView1 = FakeImageHoldingView()
        let imageView2 = FakeImageHoldingView()
        let imageView3 = FakeImageHoldingView()
        
        imageView1.expectation = XCTestExpectation(description: "setImage1")
        imageView2.expectation = XCTestExpectation(description: "setImage2")
        imageView3.expectation = XCTestExpectation(description: "setImage3")
        
        view.registerImageHandlingView(imageView1, for: "test1")
        view.registerImageHandlingView(imageView2, for: "test2")
        view.registerImageHandlingView(imageView3, for: "test3")
        
        view.dispatchImageResolveRequests()
        
        XCTAssertEqual(fakeResourceResolver.calledCount, 3)
        wait(for: [imageView1.expectation!, imageView2.expectation!, imageView3.expectation!], timeout: 0.2)
        XCTAssertTrue(imageView1.imageDidSet)
        XCTAssertTrue(imageView2.imageDidSet)
        XCTAssertTrue(imageView3.imageDidSet)
    }
    
    func testDispatchesUniqueURLRequests() {
        view.registerImageHandlingView(FakeImageHoldingView(), for: "test")
        view.registerImageHandlingView(FakeImageHoldingView(), for: "test")
        view.registerImageHandlingView(FakeImageHoldingView(), for: "test")
        view.registerImageHandlingView(FakeImageHoldingView(), for: "test")
        view.registerImageHandlingView(FakeImageHoldingView(), for: "test")
        view.registerImageHandlingView(FakeImageHoldingView(), for: "test2")
        
        view.dispatchImageResolveRequests()
        
        XCTAssertEqual(fakeResourceResolver.calledCount, 2)
        XCTAssertEqual(fakeResourceResolver.calledURLs.count, 2)
        XCTAssertEqual(fakeResourceResolver.calledURLs.sorted()[0], "test")
        XCTAssertEqual(fakeResourceResolver.calledURLs.sorted()[1], "test2")
    }
    
    func testAllImageViewIsCalled() {
        let imageView1 = FakeImageHoldingView()
        let imageView2 = FakeImageHoldingView()
        let imageView3 = FakeImageHoldingView()
        
        imageView1.expectation = XCTestExpectation(description: "setImage1")
        imageView2.expectation = XCTestExpectation(description: "setImage2")
        imageView3.expectation = XCTestExpectation(description: "setImage3")
        
        view.registerImageHandlingView(imageView1, for: "test")
        view.registerImageHandlingView(imageView2, for: "test")
        view.registerImageHandlingView(imageView3, for: "test")
        
        view.dispatchImageResolveRequests()
        
        XCTAssertEqual(fakeResourceResolver.calledCount, 1)
        wait(for: [imageView1.expectation!, imageView2.expectation!, imageView3.expectation!], timeout: 0.2)
        XCTAssertTrue(imageView1.imageDidSet)
        XCTAssertTrue(imageView2.imageDidSet)
        XCTAssertTrue(imageView3.imageDidSet)
    }
    
    // Test Submit Action is clicked
    func testSubmitActionCountValidInputV1_2() {
        view.addInputHandler(FakeInputHandlingView())
        // Empty stringg or dataJson is a valid input
        view.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        XCTAssertEqual(actionDelegate.submitActionCount, 1)
        XCTAssertEqual(actionDelegate.dictValues, 1)
    }
    
    func testSubmitActionCountInvalidInputV1_2() {
        let inputView = FakeInputHandlingView()
        inputView.isValid = false
        view.addInputHandler(inputView)
        
        view.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        XCTAssertEqual(actionDelegate.submitActionCount, 1)
        XCTAssertEqual(actionDelegate.dictValues, 1)
        XCTAssertFalse(inputView.errorShown)
    }
    
    func testSubmitActionCountValidInputV1_3() {
        let renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: renderConfig)
        view.delegate = actionDelegate
        
        let inputView = FakeInputHandlingView()
        view.addInputHandler(inputView)
        
        view.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        XCTAssertEqual(actionDelegate.submitActionCount, 1)
        XCTAssertEqual(actionDelegate.dictValues, 1)
        XCTAssertFalse(inputView.errorShown)
    }
    
    func testSubmitActionCountInvalidInputV1_3() {
        let renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: renderConfig)
        view.delegate = actionDelegate
        
        let inputView = FakeInputHandlingView()
        inputView.isValid = false
        view.addInputHandler(inputView)
        
        view.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        XCTAssertEqual(actionDelegate.submitActionCount, 0)
        XCTAssertEqual(actionDelegate.dictValues, 0)
        XCTAssertTrue(inputView.errorShown)
    }
    
    // Test when ShowCard's Submit Action is Clicked
    func testSubmitActionCountWithAShowCard() {
        let fakeShowCard = ACRView(style: .default, hostConfig: FakeHostConfig(), renderConfig: .default)
        fakeShowCard.delegate = actionDelegate
        
        view.addInputHandler(FakeInputHandlingView())
        fakeShowCard.addInputHandler(FakeInputHandlingView())
        
        fakeShowCard.parent = view
        fakeShowCard.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual(actionDelegate.submitActionCount, 1)
        XCTAssertEqual(actionDelegate.dictValues, 2)
    }
    
    // Test when ShowCard's Submit Action is clicked in nested setup
    func testSubmitActionCountWithNestedShowCard() {
        let fakeShowCard = ACRView(style: .default, hostConfig: FakeHostConfig(), renderConfig: .default)
        let fakeShowCard2 = ACRView(style: .default, hostConfig: FakeHostConfig(), renderConfig: .default)
        
        view.addInputHandler(FakeInputHandlingView())
        fakeShowCard.addInputHandler(FakeInputHandlingView())
        fakeShowCard.addInputHandler(FakeInputHandlingView())
        fakeShowCard2.addInputHandler(FakeInputHandlingView())
        
        fakeShowCard2.delegate = actionDelegate
        
        // Nested show cards
        fakeShowCard.parent = view
        fakeShowCard2.parent = fakeShowCard
        
        fakeShowCard2.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual(actionDelegate.dictValues, 4)
    }
    
    // Test when ShowCard's Submit Action is clicked with sibling showcard
    func testSubmitActionCountWithSiblingShowCard() {
        let fakeShowCard = ACRView(style: .default, hostConfig: FakeHostConfig(), renderConfig: .default)
        let fakeShowCard2 = ACRView(style: .default, hostConfig: FakeHostConfig(), renderConfig: .default)
        
        fakeShowCard.addInputHandler(FakeInputHandlingView())
        fakeShowCard2.addInputHandler(FakeInputHandlingView())
        
        fakeShowCard2.delegate = actionDelegate
        
        // sibling show cards
        fakeShowCard.parent = view
        fakeShowCard2.parent = view
        
        fakeShowCard2.handleSubmitAction(actionView: NSView(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual(actionDelegate.dictValues, 1)
    }
    
    func testBasicInputHandler() {
        let testinputHandler = FakeInputHandlingView()
        testinputHandler.value = "Value"
        testinputHandler.key = "Key"
        testinputHandler.isValid = true
        
        view.addInputHandler(testinputHandler)
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual("Value", actionDelegate.dict["Key"] as? String)
    }
    
    func testInputHandlerWhenisValidFalse() {
        let testinputHandler = FakeInputHandlingView()
        testinputHandler.value = "Value"
        testinputHandler.key = "Key"
        testinputHandler.isValid = false
        
        view.addInputHandler(testinputHandler)
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        // Submitting the field since v1.2 schema is being used and no validation is done
        XCTAssertEqual(1, actionDelegate.dict.count)
    }
    
    func testInputHandlerWithMultipleValues() {
        let testinputHandler1 = FakeInputHandlingView()
        testinputHandler1.value = "Value1"
        testinputHandler1.key = "Key1"
        testinputHandler1.isValid = true
        view.addInputHandler(testinputHandler1)
        
        let testinputHandler2 = FakeInputHandlingView()
        testinputHandler2.value = "Value2"
        testinputHandler2.key = "Key2"
        testinputHandler2.isValid = true
        view.addInputHandler(testinputHandler2)
        
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual(2, actionDelegate.dict.count)
        XCTAssertEqual("Value1", actionDelegate.dict["Key1"] as? String)
        XCTAssertEqual("Value2", actionDelegate.dict["Key2"] as? String)
    }
    
    func testInputHandlerWithDataJson() {
        let testinputHandler = FakeInputHandlingView()
        testinputHandler.value = "Value"
        testinputHandler.key = "Key"
        testinputHandler.isValid = true
        view.addInputHandler(testinputHandler)
        view.handleSubmitAction(actionView: NSButton(), dataJson: "{\"id\":\"1234567890\"}\n", associatedInputs: true)
        
        XCTAssertEqual(2, actionDelegate.dict.count)
        XCTAssertEqual("Value", actionDelegate.dict["Key"] as? String)
        XCTAssertEqual("1234567890", actionDelegate.dict["id"] as? String)
    }
    
    func testInputHandlerWithAutoAssociatedInputs() {
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: config)
        fakeResourceResolver = FakeResourceResolver()
        actionDelegate = FakeAdaptiveCardActionDelegate()
        view.resolverDelegate = fakeResourceResolver
        view.delegate = actionDelegate
        
        let testinputHandler1 = FakeInputHandlingView()
        testinputHandler1.value = "Value1"
        testinputHandler1.key = "Key1"
        testinputHandler1.isValid = true
        view.addInputHandler(testinputHandler1)
        
        let testinputHandler2 = FakeInputHandlingView()
        testinputHandler2.value = "Value2"
        testinputHandler2.key = "Key2"
        testinputHandler2.isValid = true
        view.addInputHandler(testinputHandler2)
        
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual(2, actionDelegate.dict.count)
        XCTAssertEqual("Value1", actionDelegate.dict["Key1"] as? String)
        XCTAssertEqual("Value2", actionDelegate.dict["Key2"] as? String)
    }
    
    func testInputHandlerWithNoneAssociatedInputs() {
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: config)
        fakeResourceResolver = FakeResourceResolver()
        actionDelegate = FakeAdaptiveCardActionDelegate()
        view.resolverDelegate = fakeResourceResolver
        view.delegate = actionDelegate
        
        let testinputHandler = FakeInputHandlingView()
        testinputHandler.value = "Value"
        testinputHandler.key = "Key"
        testinputHandler.isValid = true
        view.addInputHandler(testinputHandler)
        
        
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: false)
        
        XCTAssertEqual(0, actionDelegate.dict.count)
    }
    
    func testInputHandlerWithErrorMessage() {
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: config)
        fakeResourceResolver = FakeResourceResolver()
        actionDelegate = FakeAdaptiveCardActionDelegate()
        view.resolverDelegate = fakeResourceResolver
        view.delegate = actionDelegate
        
        let testinputHandler = FakeInputHandlingView()
        testinputHandler.value = "Value"
        testinputHandler.key = "Key"
        testinputHandler.isValid = false
        view.addInputHandler(testinputHandler)
        
        XCTAssertFalse(testinputHandler.errorShown)
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        XCTAssertTrue(testinputHandler.errorShown)
    }
    
    func testInputHandlers_WithHiddenViews() {
        let inputElement1 = FakeInputText.make()
        let inputElement2 = FakeInputText.make()
        let inputView1 = ACRTextInputView(textFieldWith: config, mode: .text, inputElement: inputElement1)
        let inputView2 = ACRTextInputView(textFieldWith: config, mode: .text, inputElement: inputElement2)
        
        inputView1.idString = "id-1"
        inputView1.stringValue = "hello"
        
        inputView2.idString = "id-2"
        inputView2.stringValue = "world"
        inputView2.isHidden = true
        
        view.addInputHandler(inputView1)
        view.addInputHandler(inputView2)
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertEqual(2, actionDelegate.dict.count)
        XCTAssertEqual("hello", actionDelegate.dict["id-1"] as? String)
        XCTAssertEqual("world", actionDelegate.dict["id-2"] as? String)
    }
    
    func testToggleVisibilityAction_toggleMode() {
        let tView1 = NSView.create(with: "id1")
        let tView2 = NSView.create(with: "id2")
        let target1 = FakeToggleVisibilityTarget.make(elementId: "id1", isVisible: .isVisibleToggle)
        let target2 = FakeToggleVisibilityTarget.make(elementId: "id2", isVisible: .isVisibleToggle)
        
        tView1.isHidden = true
        tView2.isHidden = false
        view.addArrangedSubview(tView1)
        view.addArrangedSubview(tView2)
        
        // views need to register with visibility manager
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView1.identifier)
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView2.identifier)
        
        view.handleToggleVisibilityAction(actionView: NSButton(), toggleTargets: [target1, target2])
        
        XCTAssertFalse(tView1.isHidden)
        XCTAssertTrue(tView2.isHidden)
    }
    
    func testToggleVisibilityAction_showMode() {
        let tView1 = NSView.create(with: "id1")
        let tView2 = NSView.create(with: "id2")
        let target1 = FakeToggleVisibilityTarget.make(elementId: "id1", isVisible: .isVisibleTrue)
        let target2 = FakeToggleVisibilityTarget.make(elementId: "id2", isVisible: .isVisibleTrue)
        
        tView1.isHidden = true
        tView2.isHidden = false
        view.addArrangedSubview(tView1)
        view.addArrangedSubview(tView2)
        
        // views need to register with visibility manager
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView1.identifier)
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView2.identifier)
        
        view.handleToggleVisibilityAction(actionView: NSButton(), toggleTargets: [target1, target2])
        
        XCTAssertFalse(tView1.isHidden)
        XCTAssertFalse(tView2.isHidden)
    }
    
    func testToggleVisibilityAction_hideMode() {
        let tView1 = NSView.create(with: "id1")
        let tView2 = NSView.create(with: "id2")
        let target1 = FakeToggleVisibilityTarget.make(elementId: "id1", isVisible: .isVisibleFalse)
        let target2 = FakeToggleVisibilityTarget.make(elementId: "id2", isVisible: .isVisibleFalse)
        
        tView1.isHidden = true
        tView2.isHidden = false
        view.addArrangedSubview(tView1)
        view.addArrangedSubview(tView2)
        
        
        // views need to register with visibility manager
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView1.identifier)
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView2.identifier)
        
        view.handleToggleVisibilityAction(actionView: NSButton(), toggleTargets: [target1, target2])
        
        XCTAssertTrue(tView1.isHidden)
        XCTAssertTrue(tView2.isHidden)
    }
    
    func testToggleVisibilityAction_mixed() {
        let tView1 = NSView.create(with: "id1")
        let tView2 = NSView.create(with: "id2")
        let tView3 = NSView.create(with: "id3")
        let target1 = FakeToggleVisibilityTarget.make(elementId: "id1", isVisible: .isVisibleToggle)
        let target2 = FakeToggleVisibilityTarget.make(elementId: "id2", isVisible: .isVisibleTrue)
        let target3 = FakeToggleVisibilityTarget.make(elementId: "id3", isVisible: .isVisibleFalse)
        
        tView1.isHidden = true
        tView2.isHidden = true
        tView3.isHidden = false
        view.addArrangedSubview(tView1)
        view.addArrangedSubview(tView2)
        view.addArrangedSubview(tView3)
        
        
        // views need to register with visibility manager
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView1.identifier)
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView2.identifier)
        view.visibilityContext?.registerVisibilityManager(view, targetViewIdentifier: tView3.identifier)
        
        view.handleToggleVisibilityAction(actionView: NSButton(), toggleTargets: [target1, target2, target3])
        
        XCTAssertFalse(tView1.isHidden)
        XCTAssertFalse(tView2.isHidden)
        XCTAssertTrue(tView3.isHidden)
    }
    
    func testVisibilityofSpacingView() {
        let hostConfig: FakeHostConfig = FakeHostConfig.make()
        let columns: [FakeColumn] = [.make(id: "id1", padding: true), .make(id: "id2", padding: true)]
        let columnSet = FakeColumnSet.make(columns: columns)
        
        let columnSetView = ColumnSetRenderer().render(element: columnSet, with: hostConfig, style: .default, rootView: view, parentView: view, inputs: [], config: .default)
        XCTAssertTrue(columnSetView is ACRContentStackView)
        
        guard let columnSetView = columnSetView as? ACRContentStackView else { fatalError() }
        view.addArrangedSubview(columnSetView)
        let target = FakeToggleVisibilityTarget.make(elementId: "id1", isVisible: .isVisibleToggle)
        
        // initially column 1 , spacing view and wrapping view are visible
        XCTAssertEqual(columnSetView.stackView.arrangedSubviews.count, 3)
        XCTAssertNotNil(columnSetView.stackView.arrangedSubviews[1] as? SpacingView)
        view.handleToggleVisibilityAction(actionView: NSButton(), toggleTargets: [target])
        XCTAssertTrue(columnSetView.stackView.arrangedSubviews[0].isHidden)
        XCTAssertTrue(columnSetView.stackView.arrangedSubviews[1].isHidden)
        XCTAssertFalse(columnSetView.stackView.arrangedSubviews[2].isHidden)
        view.handleToggleVisibilityAction(actionView: NSButton(), toggleTargets: [target])
        XCTAssertFalse(columnSetView.stackView.arrangedSubviews[0].isHidden)
        XCTAssertFalse(columnSetView.stackView.arrangedSubviews[1].isHidden)
        XCTAssertFalse(columnSetView.stackView.arrangedSubviews[2].isHidden)
    }
    
    func testInputHandlerRefocusTextFieldOnError() {
        let renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: .default)
        let view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: renderConfig)
        let handler1 = FakeInputHandlingView()
        let handler2 = FakeInputHandlingView()
        
        handler1.isValid = true
        handler2.isValid = false
        
        view.addInputHandler(handler1)
        view.addInputHandler(handler2)
        
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertFalse(handler1.isFocused)
        XCTAssertTrue(handler2.isFocused)
    }
    
    func testInputHandlerRefocusOnVisibleTextFieldOnError() {
        let renderConfig = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: .default)
        let view = ACRView(style: .default, hostConfig: FakeHostConfig.make(), renderConfig: renderConfig)
        let handler1 = FakeInputHandlingView()
        let handler2 = FakeInputHandlingView()
        
        // Case 1: First invalid view hidden so focus on second invalid view
        handler1.isValid = false
        handler1.isHidden = true
        handler2.isValid = false
        
        view.addInputHandler(handler1)
        view.addInputHandler(handler2)
        
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertFalse(handler1.isFocused)
        XCTAssertTrue(handler2.isFocused)
        
        // Case 2: First invalid view visible so focus on that and not second invalid view
        handler1.isFocused = false
        handler1.isValid = false
        handler1.isHidden = false
        
        handler2.isFocused = false
        handler2.isValid = false
        handler2.isHidden = false
        
        view.handleSubmitAction(actionView: NSButton(), dataJson: nil, associatedInputs: true)
        
        XCTAssertTrue(handler1.isFocused)
        XCTAssertFalse(handler2.isFocused)
    }
    
    func testAccessibilityFocus() throws {
        // Input Text
        let inputText = FakeInputText.make()
        let textView = try XCTUnwrap(TextInputRenderer().render(element: inputText, with: FakeHostConfig(), style: .default, rootView: self.view, parentView: self.view, inputs: [], config: self.config) as? ACRSingleLineInputTextView)
        view.addArrangedSubview(textView)
        
        // Input Text
        let inputMultiText = FakeInputText.make(isMultiline: true)
        let multiTextView = try XCTUnwrap(TextInputRenderer().render(element: inputMultiText, with: FakeHostConfig(), style: .default, rootView: self.view, parentView: self.view, inputs: [], config: self.config) as? ACRMultilineInputTextView)
        view.addArrangedSubview(multiTextView)
        
        // Input Date
        let inputDate = FakeInputDate.make()
        let dateView = try XCTUnwrap(InputDateRenderer().render(element: inputDate, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRDateField)
        view.addArrangedSubview(dateView)
        
        // Input Time
        let inputTime = FakeInputTime.make()
        let timeView = try XCTUnwrap(InputTimeRenderer().render(element: inputTime, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRDateField)
        view.addArrangedSubview(timeView)
        
        // Input Number
        let inputNumber = FakeInputNumber.make()
        let numberView = try XCTUnwrap(InputNumberRenderer().render(element: inputNumber, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRNumericTextField)
        view.addArrangedSubview(numberView)
        
        // Text Block
        let textBlock = FakeTextBlock.make(text: "Hello [Swift](www.swift.org)")
        let textBlockView = try XCTUnwrap(TextBlockRenderer().render(element: textBlock, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRTextView)
        view.addArrangedSubview(textBlockView)
        
        // Rich Text Block
        let richTextBlock = FakeRichTextBlock.make(textRun: FakeTextRun.make(text: "Hello Swift", selectAction: FakeOpenURLAction.make(url: "www.swift.org")))
        let richTextBlockView = try XCTUnwrap(RichTextBlockRenderer().render(element: richTextBlock, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRTextView)
        view.addArrangedSubview(richTextBlockView)
        
        // Fact Set
        let factset = FakeFactSet.make(factArray: [FakeFacts.make(title: "Title", value: "[Swift 5](www.swift.org)")])
        let factsetView = try XCTUnwrap(FactSetRenderer().render(element: factset, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRFactSetView)
        view.addArrangedSubview(factsetView)
        
        // Input toggle
        let inputToggle = FakeInputToggle.make(title: "Hello [Swift 5](www.swift.org)", value: "Swift")
        let inputToggleView = try XCTUnwrap(InputToggleRenderer().render(element: inputToggle, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRInputToggleView)
        view.addArrangedSubview(inputToggleView)
        
        // ChoiceSet
        let choiceSetRadio = FakeChoiceSetInput.make(isMultiSelect: false, choices: [FakeChoiceInput.make(title: "Swift", value: "Swift"), FakeChoiceInput.make(title: "ObjectiveC", value: "ObjectiveC")])
        let choiceSetRadioView = try XCTUnwrap(ChoiceSetInputRenderer().render(element: choiceSetRadio, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRChoiceSetView)
        view.addArrangedSubview(choiceSetRadioView)
        
        let choiceSetMulti = FakeChoiceSetInput.make(isMultiSelect: true, choices: [FakeChoiceInput.make(title: "Hello [Swift 5](www.swift.org)", value: "Swift"), FakeChoiceInput.make(title: "Hello ObjectiveC", value: "ObjectiveC")])
        let choiceSetMultiView = try XCTUnwrap(ChoiceSetInputRenderer().render(element: choiceSetMulti, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRChoiceSetView)
        view.addArrangedSubview(choiceSetMultiView)
        
        let choiceSetCompact = FakeChoiceSetInput.make(isMultiSelect: true, choices: [FakeChoiceInput.make(title: "Hello [Swift 5](www.swift.org)", value: "Swift"), FakeChoiceInput.make(title: "Hello ObjectiveC", value: "ObjectiveC")], choiceSetStyle: .compact)
        let choiceSetCompactView = try XCTUnwrap(ChoiceSetInputRenderer().render(element: choiceSetCompact, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRChoiceSetView)
        view.addArrangedSubview(choiceSetCompactView)
        
        // Container
        let container = FakeContainer.make(selectAction: FakeOpenURLAction.make())
        let containerView = try XCTUnwrap(ContainerRenderer().render(element: container, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRContainerView)
        view.addArrangedSubview(containerView)
        
        // ColumnSet
        let columnset = FakeColumnSet.make(columns: [FakeColumn.make(selectAction: FakeOpenURLAction.make())], selectAction: FakeOpenURLAction.make())
        let columnsetView = try XCTUnwrap(ColumnSetRenderer().render(element: columnset, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRColumnSetView)
        view.addArrangedSubview(columnsetView)
        let columnView = try XCTUnwrap(columnsetView.arrangedSubviews.first as? ACRColumnView)
        
        // Image
        let image = FakeImage.make(url: "https://adaptivecards.io/content/cats/1.png", selectAction: FakeOpenURLAction.make())
        let imageView = try XCTUnwrap(ImageRenderer().render(element: image, with: FakeHostConfig(), style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRImageWrappingView)
        view.addArrangedSubview(imageView)
        
        // actions
        let hostConfigActions = ACSActionsConfig(showCard: FakeShowCardActionConfig(actionMode: .inline, style: .accent, inlineTopMargin: 0), actionsOrientation: .vertical, actionAlignment: .center, buttonSpacing: 2, maxActions: 1, spacing: .default, iconPlacement: .aboveTitle, iconSize: NSNumber(value: 1))
        let hostConfig = FakeHostConfig.make(actions: hostConfigActions)
        let actionSet = FakeActionSet.make(actions: [FakeSubmitAction.make()])
        
        let actionSetView = try XCTUnwrap(ActionSetRenderer().render(element: actionSet, with: hostConfig, style: .default, rootView: view, parentView: view, inputs: [], config: config) as? ACRActionSetView)
        view.addArrangedSubview(actionSetView)
        
        
        XCTAssertEqual(view.accessibilityContext?.entryView, textView.validKeyView)
        
        view.accessibilityContext?.recalculateKeyViewLoop()
        
        XCTAssertEqual(textView.exitView?.validKeyView, multiTextView.validKeyView)
        XCTAssertEqual(multiTextView.exitView?.validKeyView, dateView.validKeyView)
        XCTAssertEqual(dateView.exitView?.validKeyView, timeView.validKeyView)
        XCTAssertEqual(timeView.exitView?.validKeyView, numberView.validKeyView)
        XCTAssertEqual(numberView.exitView?.validKeyView, textBlockView.validKeyView)
        XCTAssertEqual(textBlockView.exitView?.validKeyView, richTextBlockView.validKeyView)
        XCTAssertEqual(richTextBlockView.exitView?.validKeyView, factsetView.validKeyView)
        XCTAssertEqual(factsetView.exitView?.validKeyView, inputToggleView.validKeyView)
        XCTAssertEqual(inputToggleView.exitView?.validKeyView, choiceSetRadioView.validKeyView)
        XCTAssertEqual(choiceSetRadioView.exitView?.validKeyView, choiceSetMultiView.validKeyView)
        XCTAssertEqual(choiceSetMultiView.exitView?.validKeyView, choiceSetCompactView.validKeyView)
        XCTAssertEqual(choiceSetCompactView.exitView?.validKeyView, containerView.validKeyView)
        XCTAssertEqual(containerView.exitView?.validKeyView, columnsetView.validKeyView)
        XCTAssertEqual(columnsetView.exitView?.validKeyView, columnView.validKeyView)
        XCTAssertEqual(columnView.exitView?.validKeyView, imageView.validKeyView)
        XCTAssertEqual(imageView.exitView?.validKeyView, actionSetView.stackView.arrangedSubviews.first)
    }
    
}

private class FakeInputHandlingView: NSView, InputHandlingViewProtocol {
    var value: String = NSUUID().uuidString
    var key: String = NSUUID().uuidString
    var errorShown: Bool = false
    var isFocused: Bool = false
    var isValid: Bool = true
    var isRequired: Bool = false
    var isErrorShown: Bool = false
    var errorDelegate: InputHandlingViewErrorDelegate?
    func showError() {
        errorShown = true
    }
    func setAccessibilityFocus() {
        isFocused = true
    }
}

private class FakeImageHoldingView: NSView, ImageHoldingView {
    var imageDidSet = false
    var expectation: XCTestExpectation?
    func setImage(_ image: NSImage) {
        imageDidSet = true
        expectation?.fulfill()
    }
}

private extension NSView {
    static func create(with id: String) -> NSView {
        let view = NSView()
        view.identifier = NSUserInterfaceItemIdentifier(id)
        return view
    }
}
