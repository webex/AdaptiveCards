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
        guard let updatedView = viewWithInheritedProperties.arrangedSubviews[0] as? ACRColumnView else {
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
        XCTAssertTrue(view is ACRTextInputView)
        guard let inputTextView = view as? ACRTextInputView else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputText, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputTextView.errorMessageHandler = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageView?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
        inputTextView.errorMessageHandler?.hideErrorMessage(for: inputTextView)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
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
        
        inputNumberView.errorMessageHandler = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageView?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
        inputNumberView.errorMessageHandler?.hideErrorMessage(for: inputNumberView)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
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
        
        inputDateView.errorMessageHandler = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageView?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
        inputDateView.errorMessageHandler?.hideErrorMessage(for: inputDateView)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
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
        
        inputTimeView.errorMessageHandler = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageView?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
        inputTimeView.errorMessageHandler?.hideErrorMessage(for: inputTimeView)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
    }
    
    func testInputChoiceSetErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputChoiceSet = FakeChoiceSetInput.make(isRequired: true, errorMessage: "Error")
        let view = ChoiceSetInputRenderer().render(element: inputChoiceSet, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRChoiceSetView)
        guard let inputChoiceSetView = view as? ACRChoiceSetView else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputChoiceSet, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputChoiceSetView.errorMessageHandler = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageView?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
        inputChoiceSetView.errorMessageHandler?.hideErrorMessage(for: inputChoiceSetView)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
    }
    
    func testInputToggleErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeErrorMessageHandlerDelegate = FakeErrorMessageHandlerDelegate()
        
        let inputToggle = FakeInputToggle.make(isRequired: true, errorMessage: "Error")
        let view = InputToggleRenderer().render(element: inputToggle, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: config)
        XCTAssertTrue(view is ACRChoiceButton)
        guard let inputToggleView = view as? ACRChoiceButton else { fatalError() }
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: inputToggle, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        
        inputToggleView.errorMessageHandler = fakeErrorMessageHandlerDelegate
        XCTAssertEqual(updatedView.errorMessageView?.stringValue, "Error")
        XCTAssertFalse(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
        inputToggleView.errorMessageHandler?.hideErrorMessage(for: inputToggleView)
        XCTAssertTrue(fakeErrorMessageHandlerDelegate.isErrorMessageHidden)
    }
    
    private func renderBaseCardElementView() -> ACRContentStackView {
        let view = containerRenderer.render(element: container, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        XCTAssertTrue(view is ACRColumnView)
        
        let viewWithInheritedProperties = baseCardRenderer.updateView(view: view, element: container, rootView: FakeRootView(), style: .default, hostConfig: hostConfig, config: .default, isfirstElement: true)
        XCTAssertTrue(viewWithInheritedProperties is ACRContentStackView)
        
        guard let updatedView = viewWithInheritedProperties as? ACRContentStackView else { fatalError() }
        return updatedView
    }
}

private class FakeErrorMessageHandlerDelegate: ErrorMessageHandlerDelegate{
    var isErrorMessageHidden: Bool = false
    func showErrorMessage(for view: InputHandlingViewProtocol) {
        isErrorMessageHidden = false
    }
    
    func hideErrorMessage(for view: InputHandlingViewProtocol) {
        isErrorMessageHidden = true
    }
}
