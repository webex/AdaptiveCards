@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ACRInputLabelTextFieldTests: XCTestCase {
    private var labelTextField: ACRInputLabelTextField!
    private var errorView: ACRInputErrorView!
    private var config: RenderConfig!
    private var hostConfig: FakeHostConfig!
    private var inputElement: FakeInputText!
    
    override func setUp() {
        super.setUp()
        config = RenderConfig(isDarkMode: false, buttonConfig: .default, supportsSchemeV1_3: true, hyperlinkColorConfig: .default, inputFieldConfig: .default, checkBoxButtonConfig: nil, radioButtonConfig: nil, localisedStringConfig: nil)
        hostConfig = .make()
        inputElement = .make(isRequired: true, errorMessage: "Error Message", label: "This is label")
        labelTextField = ACRInputLabelTextField(inputElement: inputElement, renderConfig: config, hostConfig: FakeHostConfig(), style: .none)
        errorView = ACRInputErrorView(inputElement: inputElement, renderConfig: config, hostConfig: FakeHostConfig(), style: .none)
    }
    
    func testLabelString() throws {
        let attributedString = NSMutableAttributedString(string: "This is label")
        let errorStateConfig = config.inputFieldConfig.errorStateConfig
        let isRequiredSuffix = (hostConfig.getInputs()?.label.requiredInputs.suffix ?? "").isEmpty ? "*" : hostConfig.getInputs()?.label.requiredInputs.suffix ?? "*"
        if let colorHex = hostConfig.getForegroundColor(.default, color: .default, isSubtle: false), let textColor = ColorUtils.color(from: colorHex) {
            attributedString.addAttributes([.foregroundColor: textColor, .font: NSFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: attributedString.length))
        }
        attributedString.append(NSAttributedString(string: " " + isRequiredSuffix, attributes: [.foregroundColor: errorStateConfig.textColor, .font: NSFont.systemFont(ofSize: 16)]))
        XCTAssertEqual(attributedString, labelTextField.attributedStringValue)
    }
    
    func testErrorString() throws {
        let errorStateConfig = config.inputFieldConfig.errorStateConfig
        let attributedErrorMessageString = NSMutableAttributedString(string: "Error Message")
        
        attributedErrorMessageString.addAttributes([.font: errorStateConfig.font, .foregroundColor: errorStateConfig.textColor], range: NSRange(location: 0, length: attributedErrorMessageString.length))
        XCTAssertEqual(attributedErrorMessageString.string, errorView.errorLabel.attributedStringValue.string)
    }
}
