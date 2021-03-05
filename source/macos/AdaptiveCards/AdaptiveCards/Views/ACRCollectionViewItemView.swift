import Cocoa

class ACRCollectionViewItemView: NSView {
    var label: NSTextView?
    var box: NSView?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let newFrame = NSRect(x: 0, y: 0, width: 50, height: 50)
        box = NSView(frame: newFrame)
        box?.wantsLayer = true
        box?.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        
//        label = NSTextView(frame: NSMakeRect(0, 0, 40, 30))
//        label.string = "Label"
//        label.backgroundColor = .clear
//        box.addSubview(label)
        addSubview(box ?? NSView())
    }
}
