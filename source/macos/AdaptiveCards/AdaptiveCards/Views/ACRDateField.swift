import AdaptiveCards_bridge
import AppKit

class ACRDateField: NSView, InputHandlingViewProtocol {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = isTimeMode ? "HH:mm:ss" : "yyyy-MM-dd"
        return formatter
    }()
    
    private lazy var dateFormatterOut: DateFormatter = {
        let formatter = DateFormatter()
        if isTimeMode {
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .medium
        }
        return formatter
    }()
    
    private lazy var textField: NSTextField = {
           let view = NSTextField()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.isEditable = true
           view.isSelectable = false
           view.isBordered = true
           return view
    }()

    private lazy var iconButton: NSButton = {
       let view = NSButton(image: NSImage(named: "NSTouchBarHistoryTemplate") ?? NSImage(), target: self, action: #selector(handleButtonAction))
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    private lazy var stackview: NSStackView = {
       let view = NSStackView()
       view.orientation = .vertical
       view.alignment = .centerX
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
       
    private let datepickercalendar = NSDatePicker()
    private let datepickertextfield = NSDatePicker()

    var isTimeMode: Bool = false
    var selectedDate: Date?
    var minDateValue: String?
    var maxDateValue: String?
    var idString: String?
    var dateValue: String? {
        didSet {
            if let dateValue = dateValue, let date = dateFormatter.date(from: dateValue) {
                textField.stringValue = dateFormatterOut.string(from: date)
                selectedDate = date
            }
        }
    }
    var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                textField.placeholderString = placeholder
            }
        }
    }
    
    var value: String {
        guard let selectedDate = selectedDate else {
            return ""
        }
        return dateFormatterOut.string(from: selectedDate)
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        return !isHidden && !(superview?.isHidden ?? false)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
        setupConstraints()
        setupTrackingArea()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(textField)
        addSubview(iconButton)
    }
    
    private func setupConstraints() {
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: iconButton.leadingAnchor, constant: -10).isActive = true
        
        iconButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRDateField else { return }
        contentView.textField.backgroundColor = ColorUtils.hoverColorOnMouseEnter()
    }
    override func mouseExited(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRDateField else { return }
        contentView.textField.backgroundColor = ColorUtils.hoverColorOnMouseExit()
    }
    
    // MARK: Actions
    @objc private func handleButtonAction() {
        let frame = isTimeMode ? NSRect(x: 0, y: 0, width: 122, height: 122) : NSRect(x: 0, y: 0, width: 138, height: 147)
        if let dateValue = selectedDate {
            datepickercalendar.dateValue = dateValue
            datepickertextfield.dateValue = dateValue
        } else {
            datepickercalendar.dateValue = Date()
            datepickertextfield.dateValue = Date()
        }
        if let minDate = minDateValue, let date = dateFormatter.date(from: minDate) {
            datepickercalendar.minDate = date
            datepickertextfield.minDate = date
        }
        if let maxDate = maxDateValue, let date = dateFormatter.date(from: maxDate) {
            datepickercalendar.maxDate = date
            datepickertextfield.maxDate = date
        }
        datepickercalendar.datePickerStyle = .clockAndCalendar
        datepickercalendar.datePickerElements = isTimeMode ? .hourMinuteSecond : .yearMonthDay
        datepickercalendar.target = self
        datepickercalendar.action = #selector(handleDateAction(_:))

        datepickertextfield.datePickerElements = .yearMonthDay
        datepickertextfield.datePickerStyle = .textFieldAndStepper
        datepickertextfield.target = self
        datepickertextfield.action = #selector(handleDateAction(_:))
        if !isTimeMode { stackview.addArrangedSubview(datepickertextfield) }
        stackview.addArrangedSubview(datepickercalendar)
        let popover = NSViewController()
        popover.view = stackview
        popover.view.frame = frame
        _ = NSPopover(contentViewController: popover, sender: iconButton, bounds: frame, preferredEdge: .maxY, behavior: .transient, animates: true, delegate: nil)
    }
    
    @objc private func handleDateAction(_ datePicker: NSDatePicker) {
        textField.stringValue = dateFormatterOut.string(from: datePicker.dateValue)
        selectedDate = datePicker.dateValue
        datepickercalendar.dateValue = datePicker.dateValue
        datepickertextfield.dateValue = datePicker.dateValue
    }
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Should look for better solution
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}

extension NSPopover {
    convenience init(contentViewController: NSViewController,
                     sender: NSView,
                     bounds: NSRect,
                     preferredEdge: NSRectEdge = NSRectEdge.maxY,
                     behavior: NSPopover.Behavior? = .transient,
                     animates: Bool = true,
                     delegate: NSPopoverDelegate? = nil,
                     shouldShow: Bool = true) {
        self.init()

        if sender.window != nil {
            self.behavior = .transient
            self.contentViewController = contentViewController
            self.animates = animates
            self.delegate = delegate
            if shouldShow {
                self.show(relativeTo: bounds, of: sender, preferredEdge: preferredEdge)
            }
        } else { assert(false) }
    }
}
