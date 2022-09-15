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
        
        let view = containerRenderer.render(element: container, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        XCTAssertTrue(view is ACRContainerView)
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: container, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertEqual(fakeRootView.fittingSize.height, 200)
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
        
        let view = containerRenderer.render(element: container, with: hostConfig, style: .default, rootView: FakeRootView(), parentView: NSView(), inputs: [], config: .default)
        XCTAssertTrue(view is ACRContainerView)
        guard let view = view as? ACRContainerView else { fatalError() }
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: view, element: container, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        XCTAssertEqual(view.backgroundImageView.fillMode, .repeat)
    }
    
    func testRendererSetsId() {
        container = .make(id: "helloworld")
        let viewWithInheritedProperties = renderBaseCardElementView()
        XCTAssertEqual(viewWithInheritedProperties.identifier?.rawValue, "helloworld")
    }
    
    func testInputTextErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        
        let inputText = FakeInputText.make(id: "1", isRequired: true, errorMessage: "Error")
        let inputTextView = TextInputRenderer().render(element: inputText, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: config)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: inputTextView, element: inputText, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        
        XCTAssertTrue(inputTextView is ACRSingleLineInputTextView)
        guard let inputTextView = inputTextView as? ACRSingleLineInputTextView else { fatalError() }
        
        guard let errorMessageTextField = fakeRootView.getErrorTextField(for: inputTextView) else { fatalError() }
        
        XCTAssertEqual(errorMessageTextField.stringValue, "Error")
        XCTAssertFalse(fakeRootView.isErrorVisible(inputTextView))
        inputTextView.errorDelegate?.inputHandlingViewShouldShowError(inputTextView)
        XCTAssertTrue(fakeRootView.isErrorVisible(inputTextView))
        inputTextView.errorDelegate?.inputHandlingViewShouldHideError(inputTextView, currentFocussedView: nil)
        XCTAssertFalse(fakeRootView.isErrorVisible(inputTextView))
    }
    
    func testInputNumberErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        
        let inputElement = FakeInputNumber.make(id: "1", isRequired: true, errorMessage: "Error")
        let inputView = InputNumberRenderer().render(element: inputElement, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: config)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: inputView, element: inputElement, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        
        XCTAssertTrue(inputView is ACRNumericTextField)
        guard let inputView = inputView as? ACRNumericTextField else { fatalError() }
        
        guard let errorMessageTextField = fakeRootView.getErrorTextField(for: inputView) else { fatalError() }
        
        XCTAssertEqual(errorMessageTextField.stringValue, "Error")
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        inputView.errorDelegate?.inputHandlingViewShouldShowError(inputView)
        XCTAssertTrue(fakeRootView.isErrorVisible(inputView))
        inputView.errorDelegate?.inputHandlingViewShouldHideError(inputView, currentFocussedView: nil)
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
    }
    
    func testInputDateErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        
        let inputElement = FakeInputDate.make(id: "1", isRequired: true, errorMessage: "Error")
        let inputView = InputDateRenderer().render(element: inputElement, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: config)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: inputView, element: inputElement, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        
        XCTAssertTrue(inputView is ACRDateField)
        guard let inputView = inputView as? ACRDateField else { fatalError() }
        
        guard let errorMessageTextField = fakeRootView.getErrorTextField(for: inputView) else { fatalError() }
        
        XCTAssertEqual(errorMessageTextField.stringValue, "Error")
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        inputView.errorDelegate?.inputHandlingViewShouldShowError(inputView)
        XCTAssertTrue(fakeRootView.isErrorVisible(inputView))
        inputView.errorDelegate?.inputHandlingViewShouldHideError(inputView, currentFocussedView: nil)
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
    }
    
    func testInputTimeErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        
        let inputElement = FakeInputTime.make(id: "1", isRequired: true, errorMessage: "Error")
        let inputView = InputTimeRenderer().render(element: inputElement, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: config)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: inputView, element: inputElement, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        
        XCTAssertTrue(inputView is ACRDateField)
        guard let inputView = inputView as? ACRDateField else { fatalError() }
        
        guard let errorMessageTextField = fakeRootView.getErrorTextField(for: inputView) else { fatalError() }
        
        XCTAssertEqual(errorMessageTextField.stringValue, "Error")
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        inputView.errorDelegate?.inputHandlingViewShouldShowError(inputView)
        XCTAssertTrue(fakeRootView.isErrorVisible(inputView))
        inputView.errorDelegate?.inputHandlingViewShouldHideError(inputView, currentFocussedView: nil)
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
    }
    
    func testInputChoiceSetErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        
        let fakeChoice = FakeChoiceInput.make(title: "Title", value: "Value")
        let inputElement = FakeChoiceSetInput.make(id: "1", choices: [fakeChoice], choiceSetStyle: .compact, isRequired: true, errorMessage: "Error Message", label: "Label Message")
        let inputView = ChoiceSetInputRenderer().render(element: inputElement, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: config)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: inputView, element: inputElement, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        
        XCTAssertTrue(inputView is ACRCompactChoiceSetView)
        guard let inputView = inputView as? ACRCompactChoiceSetView else { fatalError() }
        
        guard let errorMessageTextField = fakeRootView.getErrorTextField(for: inputView) else { fatalError() }
        
        XCTAssertEqual(errorMessageTextField.stringValue, "Error Message")
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        XCTAssertEqual(inputView.accessibilityValue() as? String, "Label Message, Title")
        
        inputView.errorDelegate?.inputHandlingViewShouldShowError(inputView)
        XCTAssertTrue(fakeRootView.isErrorVisible(inputView))
        XCTAssertEqual(inputView.accessibilityValue() as? String, "Error Error Message, Label Message, Title")
        
        inputView.errorDelegate?.inputHandlingViewShouldHideError(inputView, currentFocussedView: nil)
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        XCTAssertEqual(inputView.accessibilityValue() as? String, "Label Message, Title")
    }
    
    func testInputToggleErrorMessageHandler() {
        let config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        let fakeRootView = ACRView.init(style: .none, hostConfig: hostConfig, renderConfig: config)
        
        let inputElement = FakeInputToggle.make(id: "1", title: "Title", isRequired: true, errorMessage: "Error Message", label: "Label")
        let inputView = InputToggleRenderer().render(element: inputElement, with: hostConfig, style: .default, rootView: fakeRootView, parentView: fakeRootView, inputs: [], config: config)
        
        BaseCardElementRenderer.shared.updateLayoutForSeparatorAndAlignment(view: inputView, element: inputElement, parentView: fakeRootView, rootView: fakeRootView, style: .none, hostConfig: hostConfig, config: config, isfirstElement: true)
        
        XCTAssertTrue(inputView is ACRInputToggleView)
        guard let inputView = inputView as? ACRInputToggleView else { fatalError() }
        
        guard let errorMessageTextField = fakeRootView.getErrorTextField(for: inputView) else { fatalError() }
        
        XCTAssertEqual(errorMessageTextField.stringValue, "Error Message")
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        XCTAssertEqual(inputView.accessibilityLabel(), "Label, Title")
        
        inputView.errorDelegate?.inputHandlingViewShouldShowError(inputView)
        XCTAssertTrue(fakeRootView.isErrorVisible(inputView))
        XCTAssertEqual(inputView.accessibilityLabel(), "Error, Error Message, Label, Title")
        
        inputView.errorDelegate?.inputHandlingViewShouldHideError(inputView, currentFocussedView: nil)
        XCTAssertFalse(fakeRootView.isErrorVisible(inputView))
        XCTAssertEqual(inputView.accessibilityLabel(), "Label, Title")
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
