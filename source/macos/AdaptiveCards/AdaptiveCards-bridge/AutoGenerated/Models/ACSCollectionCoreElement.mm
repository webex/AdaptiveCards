// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSCollectionCoreElement.h"
#import "CollectionCoreElement.h"



@implementation  ACSCollectionCoreElement {
    std::shared_ptr<CollectionCoreElement> mCppObj;
}

- (instancetype _Nonnull)initWithCollectionCoreElement:(const std::shared_ptr<CollectionCoreElement>)cppObj
{
    if (self = [super initWithBaseCardElement: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}




@end