import AdaptiveCards_bridge
import AppKit

open class InputTimeRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = InputTimeRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let timeElement = element as? ACSTimeInput else {
            logError("Element is not of type ACSDateInput")
            return NSView()
        }

        // setting up basic properties for Input.Time Field
        let inputField: ACRDateField = {
            let view = ACRDateField(isTimeMode: true)
            let timeValue = timeElement.getValue() ?? ""
            let timeMin = timeElement.getMin() ?? ""
            let timeMax = timeElement.getMax() ?? ""
            view.translatesAutoresizingMaskIntoConstraints = false
            view.maxDateValue = timeMax
            view.minDateValue = timeMin
            view.dateValue = timeValue
            view.placeholder = timeElement.getPlaceholder() ?? ""
            view.idString = timeElement.getId()
            view.isHidden = !timeElement.getIsVisible()
            return view
        }()
        
        rootView.addInputHandler(inputField)
        return inputField
    }
}
