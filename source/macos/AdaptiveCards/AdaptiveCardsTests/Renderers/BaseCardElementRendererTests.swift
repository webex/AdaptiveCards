@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class BaseCardElementRendererrTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var container: FakeContainer!
    private var backgroundImage: FakeBackgroundImage!
    private var baseCardRenderer: BaseCardElementRenderer!
    private var containerRenderer: ContainerRenderer!
   
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        container = .make()
        baseCardRenderer = BaseCardElementRenderer()
        containerRenderer = ContainerRenderer()
        
    }
    
    func testRendererSetsMinHeight() {
        container = .make(minHeight: 200)
        let viewWithInheritedProperties = renderBaseCardElementView()
        XCTAssertEqual(viewWithInheritedProperties.fittingSize.height, 200)
    }
    
    func testRendererSetsVisible() {
        container = .make(visible: true)
        var viewWithInheritedProperties = renderBaseCardElementView()
        XCTAssertEqual(viewWithInheritedProperties.isHidden, false)
        
        container = .make(visible: false)
        viewWithInheritedProperties = renderBaseCardElementView()
        XCTAssertEqual(viewWithInheritedProperties.isHidden, true)
    }
    
    func testRendererSetsBackgroundImage() {
        backgroundImage = .make(url: "https://picsum.photos/200", fillMode: .repeat)
        container = .make(backgroundImage: backgroundImage)
        let viewWithInheritedProperties = renderBaseCardElementView()
        guard let updatedView = viewWithInheritedProperties.arrangedSubviews[0] as? ACRContainerView else {
            fatalError()
        }
        XCTAssertEqual(updatedView.backgroundImageView.fillMode, .repeat)
    }
    
    func testRendererSetsId() {
        container = .make(id: "helloworld")
        let viewWithInheritedProperties = renderBaseCardElementView()
        XCTAssertEqual(viewWithInheritedProperties.identifier?.rawValue, "helloworld")
    }
    
    func testInputTextErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputText = FakeInputText.make(isRequired: true, errorMessage: "Error")
        let view = TextInputRenderer().render(element: inputText, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRSingleLineInputTextView)
        guard let inputTextView = view as? ACRSingleLineInputTextView else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputText, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputTextView.errorDelegate = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageField?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorVisible)
        inputTextView.errorDelegate?.inputHandlingViewShouldHideError(inputTextView, currentFocussedView: nil)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorVisible)
    }
    
    func testInputNumberErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputNumber = FakeInputNumber.make(isRequired: true, errorMessage: "Error")
        let view = InputNumberRenderer().render(element: inputNumber, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRNumericTextField)
        guard let inputNumberView = view as? ACRNumericTextField else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputNumber, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputNumberView.errorDelegate = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageField?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorVisible)
        inputNumberView.errorDelegate?.inputHandlingViewShouldHideError(inputNumberView, currentFocussedView: nil)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorVisible)
    }
    
    func testInputDateErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputDate = FakeInputDate.make(isRequired: true, errorMessage: "Error")
        let view = InputDateRenderer().render(element: inputDate, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRDateField)
        guard let inputDateView = view as? ACRDateField else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputDate, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputDateView.errorDelegate = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageField?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorVisible)
        inputDateView.errorDelegate?.inputHandlingViewShouldHideError(inputDateView, currentFocussedView: nil)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorVisible)
    }
    
    func testInputTimeErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputTime = FakeInputTime.make(isRequired: true, errorMessage: "Error")
        let view = InputTimeRenderer().render(element: inputTime, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRDateField)
        guard let inputTimeView = view as? ACRDateField else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputTime, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputTimeView.errorDelegate = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageField?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorVisible)
        inputTimeView.errorDelegate?.inputHandlingViewShouldHideError(inputTimeView, currentFocussedView: nil)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorVisible)
    }
    
    func testInputChoiceSetErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        let fakeChoice = FakeChoiceInput.make(title: "Title", value: "Value")
        let inputChoiceSet = FakeChoiceSetInput.make(choices: [fakeChoice], choiceSetStyle: .compact, isRequired: true, errorMessage: "Error Message", label: "Label Message")
        let view = ChoiceSetInputRenderer().render(element: inputChoiceSet, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRCompactChoiceSetView)
        guard let inputChoiceSetView = view as? ACRCompactChoiceSetView else { fatalError() }
        inputChoiceSetView.choiceSetPopup.errorDelegate = fakeErrorMessageHandlerDelegate
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorVisible)
        XCTAssertEqual(inputChoiceSetView.choiceSetPopup.accessibilityValue() as? String, "Label Message, Title")
        inputChoiceSetView.choiceSetPopup.errorDelegate?.inputHandlingViewShouldHideError(inputChoiceSetView.choiceSetPopup, currentFocussedView: nil)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorVisible)
        XCTAssertEqual(inputChoiceSetView.choiceSetPopup.accessibilityValue() as? String, "Error Error Message, Label Message, Title")
    }
    
    func testInputToggleErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputToggle = FakeInputToggle.make(title: "Title", isRequired: true, errorMessage: "Error Message", label: "Label")
        let view = InputToggleRenderer().render(element: inputToggle, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRInputToggleView)
        guard let inputToggleView = view as? ACRInputToggleView else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputToggle, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputToggleView.errorDelegate = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageField?.stringValue, "Error Message")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorVisible)
        XCTAssertEqual(inputToggleView.accessibilityLabel(), "Label, Title")
        inputToggleView.errorDelegate?.inputHandlingViewShouldHideError(inputToggleView, currentFocussedView: nil)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorVisible)
        XCTAssertEqual(inputToggleView.accessibilityLabel(), "Error, Error Message, Label, Title")
    }
    
    private func renderBaseCardElementView() -> ACRContentStackView {
        let view = containerRenderer.render(element: container, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        XCTAssertTrue(view is ACRContainerView)
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: container, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: .default, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        return updatedView
    }
}
