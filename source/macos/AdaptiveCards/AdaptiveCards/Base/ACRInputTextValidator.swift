import AdaptiveCards_bridge
import AppKit

class ACRInputTextValidator {
    var isRequired = false
    var regex: String? {
        didSet {
            // handling case when regex is not supplied and is set to "". Replacing it with nil
            if let currValue = regex, currValue.isEmpty {
                regex = nil
            }
        }
    }
    
    func getIsValid(for inputString: String) -> Bool {
        if inputString.isEmpty {
            return !isRequired
        }
        guard let regexString = regex else { return true }
        return inputString.range(of: regexString, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
