import Cocoa

class ACRCollectionViewItemView: NSView {
    var label: NSTextView?
    var box: NSView?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
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
        
        box = NSView(frame: .zero)
        
        guard let box = box else {
            addSubview(NSView())
            return
        }
        box.wantsLayer = true
        box.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
//        elemHeight = 50
        
//        label = NSTextView(frame: NSMakeRect(0, 0, 40, 30))
//        label.string = "Label"
//        label.backgroundColor = .clear
//        box.addSubview(label)
        addSubview(box)
//        box.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        box.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        box.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        box.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
