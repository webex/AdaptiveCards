import AdaptiveCards_bridge
import AppKit

class ActionSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ActionSetRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let actionSet = element as? ACSActionSet else {
            logError("Element is not of type ACSActionSet")
            return NSView()
        }
        let actionSetView: NSStackView = {
            let view = NSStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
//        actionSetView.distribution = .equalSpacing
        let adaptiveActionHostConfig = hostConfig.getActions()
        if let orientation = adaptiveActionHostConfig?.actionsOrientation, orientation == .horizontal {
            actionSetView.orientation = .horizontal
        } else {
            actionSetView.orientation = .vertical
            let alignment = actionSetView.alignment
            if let actionAlignment = adaptiveActionHostConfig?.actionAlignment {
                switch actionAlignment {
                case .center:
                    actionSetView.alignment = .centerX
                    actionSetView.alignment = .centerY
                case .left:
                    actionSetView.alignment = .leading
                case .right:
                    actionSetView.alignment = .trailing
                default:
                    actionSetView.alignment = alignment
                }
            }
        }
        var accumulatedWidth = 0, accumulatedHeight = 0, maxWidth = 0, maxHeight = 0
//        if let spacing = adaptiveActionHostConfig?.buttonSpacing {
//            actionSetView.spacing = CGFloat(spacing.doubleValue)
//        }
        if actionSet.getActions().isEmpty {
            return actionSetView
        }
        var actionsToRender: Int = 0
        if let uMaxActionsToRender = adaptiveActionHostConfig?.maxActions, let maxActionsToRender = uMaxActionsToRender as? Int {
            actionsToRender = min(maxActionsToRender, actionSet.getActions().count)
        }
        var actions: [NSView] = []
        for index in 0..<actionsToRender {
            let action = actionSet.getActions()[index]
            let renderer = RendererManager.shared.actionRenderer(for: action.getType())
            if let curView = rootView as? ACRView {
                let view = renderer.render(action: action, with: hostConfig, style: style, rootView: curView, parentView: rootView, inputs: [])
                actions.append(view)
                actionSetView.addArrangedSubview(view)
            }
        }
        
        return actionSetView
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
//
//
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
