import AdaptiveCards_bridge
import AppKit

open class InputTimeRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = InputTimeRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let timeElement = element as? ACSTimeInput else {
            logError("Element is not of type ACSDateInput")
            return NSView()
        }

        // setting up basic properties for Input.Time Field
        let inputField: ACRDateField = {
            let view = ACRDateField()
            view.isTimeMode = true
            let values: [String] = (timeElement.getValue() ?? "").components(separatedBy: ":")
            let timeValue: String = appendSecondsIfMissing(value: values)
            
            let minvalues: [String] = (timeElement.getMin() ?? "").components(separatedBy: ":")
            let timeMin: String = appendSecondsIfMissing(value: minvalues)
            
            let maxvalues: [String] = (timeElement.getMax() ?? "").components(separatedBy: ":")
            let timeMax: String = appendSecondsIfMissing(value: maxvalues)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.maxDateValue = timeMax
            view.minDateValue = timeMin
            view.dateValue = timeValue
            view.placeholder = timeElement.getPlaceholder() ?? ""
            return view
        }()
        return inputField
    }
    // if input time doesn't have seconds then this function appends seconds' value as 00
    func appendSecondsIfMissing(value: [String]) -> String {
        var time: [String] = value
        if value.count == 2 {
            time.append("00")
        }
        return time.joined(separator: ":")
    }
}
