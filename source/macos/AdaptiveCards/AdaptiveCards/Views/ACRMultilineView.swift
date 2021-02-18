import AppKit
let PLACEHOLDERTEXT = "Sample Placeholder"
class ACRMultilineView: NSView, NSTextViewDelegate {
    @IBOutlet var contentView: NSView!
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    
    init() {
            super.init(frame: .zero)
            guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards") else {
                logError("Bundle is nil")
                return
            }
            bundle.loadNibNamed("ACRMultilineView", owner: self, topLevelObjects: nil)
            setupViews()
            setupConstaints()
        }
    
    private func setupViews() {
            addSubview(contentView)
        }
    
    private func setupConstaints() {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.borderType = .lineBorder
        textView.delegate = self
    }
    
    func setPlaceholder(placeholder: String) {
//        let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
//        attributedPlaceholder.addAttributes([.foregroundColor: NSColor.lightGray], range: NSRange(location: 0, length: attributedPlaceholder.length))
//        textView.textStorage?.setAttributedString(attributedPlaceholder)
        applyPlaceholderStyle(textView, PLACEHOLDERTEXT)
    }
    
    func setValue(value: String) {
        let attributedValue = NSMutableAttributedString(string: value)
        textView.textStorage?.setAttributedString(attributedValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Trying Grokswift here
    func applyPlaceholderStyle(_ aTextView: NSTextView, _ placeholderText: String) {
        aTextView.textColor = NSColor.lightGray
        aTextView.string = placeholderText
    }
    
    func applyNonPlaceholderStyle(_ aTextView: NSTextView) {
        aTextView.textColor = NSColor.black
    }
    
    func textViewShouldBeginEditing(aTextView: NSTextView) -> Bool {
        if aTextView == textView && aTextView.string == PLACEHOLDERTEXT {
            moveCursorToStart(aTextView)
        }
        return true
    }
    
    func moveCursorToStart(_ aTextView: NSTextView) {
        DispatchQueue.main.async {
            aTextView.setSelectedRange(NSRange(location: 0, length: 0))
        }
    }
    
    func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementString text: String?) -> Bool {
        let newLength = self.textView.string.utf16.count + (text?.utf16.count ?? 0) - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
          // check if the only text is the placeholder and remove it if needed
          // unless they've hit the delete button with the placeholder displayed
            if self.textView == textView && self.textView.string == PLACEHOLDERTEXT {
                if ((text?.utf16.count) == 0)// they hit the back button
            {
              return false // ignore it
            }
                applyNonPlaceholderStyle(self.textView)
                textView.string = text ?? ""
          }
          return true
        } else { // no text, so show the placeholder
            applyPlaceholderStyle(self.textView, PLACEHOLDERTEXT)
            moveCursorToStart(textView)
          return false
        }
      }
}
// class TextViewWithPlaceholder {
//    static NSAttributedString *placeHolderString;
//
//    @implementation TextViewWithPlaceHolder
//
//    +(void)initialize
//    {
//    static BOOL initialized = NO;
//    if (!initialized)
//    {
//    NSColor *txtColor = [NSColor grayColor];
//    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
//    placeHolderString = [[NSAttributedString alloc] initWithString:@"This is my placeholder text" attributes:txtDict];
//    }
//    }
//
//    - (BOOL)becomeFirstResponder
//    {
//      [self setNeedsDisplay:YES];
//      return [super becomeFirstResponder];
//    }
//
//    - (void)drawRect:(NSRect)rect
//    {
//    [super drawRect:rect];
//    if ([[self string] isEqualToString:@""] && self != [[self window] firstResponder])
//    [placeHolderString drawAtPoint:NSMakePoint(0,0)];
//    }
//
//    - (BOOL)resignFirstResponder
//    {
//      [self setNeedsDisplay:YES];
//      return [super resignFirstResponder];
//    }
//
//    @end
// }
