import AdaptiveCards_bridge
import AppKit

class ActionSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ActionSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let actionSet = element as? ACSActionSet else {
            logError("Element is not of type ACSActionSet")
            return NSView()
        }
//        let actionSetView: NSStackView = {
//            let view = NSStackView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
//        }()
        let actionSetView = ACRActionView()
        actionSetView.translatesAutoresizingMaskIntoConstraints = false
//        actionSetView.distribution = .fillProportionally
        let adaptiveActionHostConfig = hostConfig.getActions()
        if let orientation = adaptiveActionHostConfig?.actionsOrientation, orientation == .horizontal {
            actionSetView.orientation = .horizontal
        } else {
            actionSetView.orientation = .vertical
//            let alignment = actionSetView.alignment
//            if let actionAlignment = adaptiveActionHostConfig?.actionAlignment {
//                switch actionAlignment {
//                case .center:
//                    actionSetView.alignment = .centerX
//                case .left:
//                    actionSetView.alignment = .leading
//                case .right:
//                    actionSetView.alignment = .trailing
//                default:
//                    actionSetView.alignment = alignment
//                }
//            }
        }
        var accumulatedWidth = 0, accumulatedHeight = 0, maxWidth = 0, maxHeight = 0
        if actionSet.getActions().isEmpty {
            return actionSetView
        }
        var actionsToRender: Int = 0
        if let uMaxActionsToRender = adaptiveActionHostConfig?.maxActions, let maxActionsToRender = uMaxActionsToRender as? Int {
            actionsToRender = min(maxActionsToRender, actionSet.getActions().count)
        }
//        var actions: [NSView] = []
        if let spacing = adaptiveActionHostConfig?.buttonSpacing {
            actionSetView.spacingview = CGFloat(spacing.doubleValue)
            accumulatedWidth += Int(truncating: spacing) * actionsToRender
            actionSetView.padding = CGFloat(truncating: spacing)
        }
        
        for index in 0..<actionsToRender {
            let action = actionSet.getActions()[index]
            let renderer = RendererManager.shared.actionRenderer(for: action.getType())
            if let curView = rootView as? ACRView {
                let view = renderer.render(action: action, with: hostConfig, style: style, rootView: curView, parentView: rootView, inputs: [])
                
                actionSetView.addToStack(view)
                accumulatedWidth += Int(view.intrinsicContentSize.width)
                accumulatedHeight += Int(view.intrinsicContentSize.height)
                actionSetView.actions.append(view)
            }
        }
        
        actionSetView.buttonActions = actionSet.getActions()
        actionSetView.totalWidth = CGFloat(accumulatedWidth)
        actionSetView.actionsToRender = actionsToRender
        actionSetView.rootView = rootView
        
        return actionSetView
    }
}
// MARK: NEW VIEW
class ACRActionView: NSStackView {
    private lazy var stackview: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var gridView: NSGridView = {
       let view = NSGridView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var width: CGFloat = 0
    var totalWidth: CGFloat = 0
    var actions: [NSView] = []
    var padding: CGFloat = 0
    var buttonActions: [ACSBaseActionElement] = []
    var actionsToRender = 0
    var rootView: NSView?
    var cnt = 0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(stackview)
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override var intrinsicContentSize: NSSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func outOfSuperviewBounds() -> Bool {
        guard let superview = self.superview else {
            return true
        }
        let intersectedFrame = superview.bounds.intersection(self.frame)
        let isInBounds = abs(intersectedFrame.origin.x - self.frame.origin.x) < 1 &&
            abs(intersectedFrame.origin.y - self.frame.origin.y) < 1 &&
            abs(intersectedFrame.size.width - self.frame.size.width) < 1 &&
            abs(intersectedFrame.size.height - self.frame.size.height) < 1
        return !isInBounds
    }
    
    func setupGrid() {
        addSubview(gridView)
        gridView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gridView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupStackView(_ view: NSStackView) {
        print("how many ", arrangedSubviews.capacity)
        addArrangedSubview(view)
    }
    
    func customLayout() {
        // do custom work
        
        if width != 0, width < totalWidth {
            print("here", width, "---", totalWidth)
            // iterate fill first stackview, then fill another stackview
            setupGrid()
            var buttonwidth: CGFloat = 0
            var actionInRow: [NSView] = []
            removeElements()
            stackview.removeFromSuperview()
            for view in actions {
                buttonwidth += view.intrinsicContentSize.width
                buttonwidth += padding
                if buttonwidth > width {
                    gridView.addRow(with: actionInRow)
                    buttonwidth = 0
                    buttonwidth += view.intrinsicContentSize.width
                    actionInRow.removeAll()
                    actionInRow.append(view)
                } else {
//                    stackview.addArrangedSubview(view)
                    actionInRow.append(view)
                }
            }
//            gridView.addRow(with: actionInRow)
//            addSubview(gridView)
            totalWidth = buttonwidth
            if !actionInRow.isEmpty {
                print(actionInRow[0].bounds, "bounds")
                gridView.addRow(with: actionInRow)
            }
        }
        return
    }
    
    func customLayoutTwo() {
        if width != 0, width < totalWidth {
            // print("second-width", width, "---", totalWidth)
            // iterate fill first stackview, then fill another stackview
            var buttonwidth: CGFloat = 0
            
            removeElements()
            
            var curview = NSStackView()
            curview.translatesAutoresizingMaskIntoConstraints = false
            curview.spacing = padding
//            curview.spacing = padding
//            addSubview(stackview)
//            setupConstraints()
            stackview.addArrangedSubview(curview)
            stackview.orientation = .vertical
            stackview.alignment = .trailing
             for view in actions {
                buttonwidth += view.intrinsicContentSize.width
                buttonwidth += padding
                if buttonwidth > width {
                    let newStackView: NSStackView = {
                       let view = NSStackView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        return view
                    }()
                    curview = newStackView
                    curview.addArrangedSubview(view)
                    curview.spacing = padding
                    buttonwidth = 0
                    buttonwidth += view.intrinsicContentSize.width
                    stackview.addArrangedSubview(newStackView)
                } else {
                    curview.addArrangedSubview(view)
                }
            }
        }
        return
    }
    
    func removeElements() {
        for view in stackview.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    override func layout() {
        super.layout()
        width = frame.width
        print(width, "-", totalWidth)
        if orientation == .horizontal, cnt == 0 {
            customLayoutTwo()
//            customLayout()
            cnt = 1
        }
    }
    override var orientation: NSUserInterfaceLayoutOrientation {
        get { stackview.orientation }
        set {
            stackview.orientation = newValue
        }
    }
    
    override var alignment: NSLayoutConstraint.Attribute {
        get { stackview.alignment }
        set {
            stackview.alignment = newValue
        }
    }
    
     var spacingview: CGFloat {
        get { stackview.spacing }
        set {
            stackview.spacing = newValue
            spacing = newValue
        }
    }
    
    func addToStack(_ view: NSView) {
        stackview.addArrangedSubview(view)
    }
}

// MARK: NSCOLLECTION VIEW TEST
// class ACRActionSet: NSCollectionView {
//    var actionSet: ACSActionSet?
//    var hostConfig: ACSHostConfig?
//    var actionSize: NSSize?
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    init(frame frameRect: NSRect, actionSet: ACSActionSet, hostConfig: ACSHostConfig) {
//        super.init(frame: frameRect)
//
//        let spacing: CGFloat = 2
//        self.actionSet = actionSet
//        self.hostConfig = hostConfig
//        self.actionSize = NSSize(width: 30, height: 30)
//        let layout = NSCollectionViewFlowLayout()
//        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        // TODO: Change minimumLineSpacing to 0 after adding images
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
//        if let size = actionSize {
//            layout.itemSize = size
//        }
//        collectionViewLayout = layout
//
//        self.backgroundColors = [.clear]
//
//        //        register(ACRActionItem.self, forItemWithIdentifier: ACRActionItem.identifier)
//    }
//
//    func newIntrinsicContentSize() -> CGSize {
//        guard let layout = collectionViewLayout as? NSCollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
//        let cellCounts = actionSet?.getActions().count ?? 0
//        let newImageSize = layout.itemSize
//        let spacing = layout.minimumInteritemSpacing
//        let lineSpacing = layout.minimumLineSpacing
//        let frameWidth = frame.size.width
//        let imageSizeWithSpacing = newImageSize.width + spacing
//
//        var numberOfItemsPerRow = Int(frameWidth / imageSizeWithSpacing)
//        if CGFloat(numberOfItemsPerRow) * imageSizeWithSpacing + newImageSize.width <= frameWidth {
//            numberOfItemsPerRow += 1
//        }
//
//        guard numberOfItemsPerRow > 0 else { return CGSize(width: 0, height: 0) }
//
//        let numberOfRows = Int(ceil(Float(cellCounts) / Float(numberOfItemsPerRow)))
//
//        return CGSize(width: frameWidth, height: (CGFloat(numberOfRows) * (newImageSize.height) + ((CGFloat(numberOfRows) - 1) * lineSpacing)))
//    }
//
//    override var intrinsicContentSize: NSSize {
//        return newIntrinsicContentSize()
//    }
//
//    override func viewDidMoveToSuperview() {
//        super.viewDidMoveToSuperview()
//        guard let view = superview else { return }
//        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//    }
// }

// class ACRCollectionActionDataSource: NSObject, NSCollectionViewDataSource {
//    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
//        return
//    }
//
//    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
//        // test
//    }
//    func numberOfSections(in collectionView: NSCollectionView) -> Int {
//        return 1
//    }
// }
// extension ACRCollectionActionDataSource: NSCollectionViewDelegate {}

// extension ACRCollectionActionDataSource: NSCollectionViewDelegateFlowLayout {}

// class ACRActionItem: NSCollectionViewItem {
//    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "MyItem")
// }
