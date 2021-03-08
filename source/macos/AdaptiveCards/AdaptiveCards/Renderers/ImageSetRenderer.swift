import AdaptiveCards_bridge
import AppKit

class ImageSetRenderer: NSObject, BaseCardElementRendererProtocol {
    static let shared = ImageSetRenderer()
    let collectionViewDataSource = ACRCollectionViewDatasource()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let imageSet = element as? ACSImageSet else {
            logError("Element is not of type ACSImageSet")
            return NSView()
        }
        let newFrame = NSRect(x: 0, y: 0, width: 50, height: 50)
//        let colView = ACRCollectionView(frame: newFrame)
        let colView = CustomClass().collectionView
        let mainView = NSView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        colView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewDataSource.setupView(colView)
        colView.dataSource = collectionViewDataSource
        colView.delegate = collectionViewDataSource
        
//        let numberOfSections = colView.numberOfSections
//        let numberOfItems = colView.numberOfItems(inSection: 0)
//        let numberOfItemsInRow: CGFloat = 8
//        let totalNumberOfRows = Int(ceil(Double(numberOfItems / numberOfItemsInRow))) * numberOfSections
//        let totalHeight: CGFloat = (2 * spacing) + (totalNumberOfRows - 1) * spacing
//        colView.newIntrinsicContentSize()
        
        let height = collectionViewDataSource.getHeightOfView()
        
        colView.heightAnchor.constraint(equalToConstant: height).isActive = true
//        mainView.addSubview(colView)
//        colView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
//        colView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
//        colView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
//        colView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
//        print(colView.collectionViewLayout?.collectionViewContentSize)
        return colView
    }
}
