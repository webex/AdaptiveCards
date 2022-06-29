import Foundation

func logError(_ message: Any..., function: String = #function, file: String = #file, line: Int = #line) {
    logPrint(type: .error, message: message, function: function, file: file, line: line)
}

func logInfo(_ message: Any..., function: String = #function, file: String = #file, line: Int = #line) {
    logPrint(type: .info, message: message, function: function, file: file, line: line)
}

private enum LogType {
    case error, info
    
    var title: String {
        switch self {
        case .error: return "ERROR"
        case .info: return "INFO "
        }
    }
}

private func logPrint(type: LogType, message: [Any], function: String, file: String, line: Int) {
    let fileName = URL(string: file)?.lastPathComponent ?? file
    let joined = message.map { String(describing: $0) }.joined(separator: " ")
    /// print("\(type.title): #\(line) \(function) \(fileName): ", joined)
    SparkCardLogDebuger.print("\(type.title):: #\(line) \(function): \(joined)")
}

class SparkCardLogDebuger {
    /// Debug Log For Spark-client
    /// Spark observer will recived log messages
    /// - Parameter msg: debug log message
    class func print(_ msg: Any?) {
        let userInfoLog = ["logMsg": "AdaptiveCardsDebugLog ## \(msg ?? "")"]
        AdaptiveCardStationCenter.shared.publishDebug(log: userInfoLog)
    }
}
// MARK: - Spark Log Debugger Observer
public enum AdaptiveCardObservedType {
    case debug
}

public protocol AdaptiveCardObserver: AnyObject {}

public protocol AdaptiveCardSparkDebugObserver: AdaptiveCardObserver {
    func debugPrint(log msg: Any?)
}

/// Wrapper class that will hold the weak value of subscribers else VCs are gonna be retained
/// since they will be stored inside array that lives in Subject singleton object (that is alive through whole application lifecycle)
public class WeakAdaptiveCardObserver {
    weak var value: AdaptiveCardObserver?
    var types: Set<AdaptiveCardObservedType>
    
    init(value: AdaptiveCardObserver?, subscribedFor types: [AdaptiveCardObservedType]) {
        self.value = value
        self.types = Set(types)
    }
}

public protocol AdaptiveCardStationProtocol: AnyObject {
    func subscribe(_ observer: AdaptiveCardObserver, for types: AdaptiveCardObservedType...)
    func unsubscribe(_ observer: AdaptiveCardObserver, from type: AdaptiveCardObservedType)
    func unsubscribe(_ observer: AdaptiveCardObserver)
    func unsubscribeReleasedObservers() // Used for unsubscribing all observers that are nil
}

public class AdaptiveCardStationCenter: AdaptiveCardStationProtocol {
    public static let shared = AdaptiveCardStationCenter()
    
    private init() { }
    
    private var observers: [WeakAdaptiveCardObserver] = []
    
    public func subscribe(_ observer: AdaptiveCardObserver, for types: AdaptiveCardObservedType...) {
        let existingObserverIndex = observers.firstIndex(where: { $0.value === observer })
        
        if let index = existingObserverIndex {
            types.forEach({ observers[index].types.insert($0) })
        } else {
            observers.append(WeakAdaptiveCardObserver(value: observer, subscribedFor: types))
        }
        logInfo("Number of subscribers: \(observers.count)")
    }
    
    public func unsubscribe(_ observer: AdaptiveCardObserver, from type: AdaptiveCardObservedType) {
        guard let index = observers.firstIndex(where: { $0.value === observer }) else { return } // Address comparison
        observers[index].types.remove(type)
        logInfo("Number of subscribers: \(observers.count)")
    }
    
    public func unsubscribe(_ observer: AdaptiveCardObserver) {
        observers = observers.filter({ $0.value !== observer })
        logInfo("Number of subscribers: \(observers.count)")
    }
    
    // This method has to be called manually on deinit of some observer object
    public func unsubscribeReleasedObservers() {
        observers = observers.filter({ $0.value != nil })
        logInfo("Number of subscribers: \(observers.count)")
    }
}

extension AdaptiveCardStationCenter {
    public func publishDebug(log msg: Any?) {
        observers.filter({ $0.types.contains(.debug) }).forEach { observer in
            guard let cardObserver = observer.value as? AdaptiveCardSparkDebugObserver else { return }
            cardObserver.debugPrint(log: msg)
        }
    }
}
