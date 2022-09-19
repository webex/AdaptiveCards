import AdaptiveCards_bridge
import AppKit

open class InputDateRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = InputDateRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let dateElement = element as? ACSDateInput else {
            logError("Element is not of type ACSDateInput")
            return NSView()
        }

        // setting up basic properties for Input.Date Field
        let inputField: ACRDateField = {
            let view = ACRDateField(isTimeMode: false, config: config, inputElement: dateElement)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isRequired = dateElement.getIsRequired()
            view.maxDateValue = dateElement.getMax() ?? ""
            view.minDateValue = dateElement.getMin() ?? ""
            view.initialDateValue = dateElement.getValue() ?? ""
            view.placeholder = dateElement.getPlaceholder() ?? ""
            view.idString = dateElement.getId()
            return view
        }()
        
        rootView.addInputHandler(inputField)
        if dateElement.getHeight() == .stretch {
            inputField.setStretchableHeight()
        }
        return inputField
    }
}
