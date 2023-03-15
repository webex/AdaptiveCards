// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSTableCell.h"
#import "TableCell.h"



@implementation  ACSTableCell {
    std::shared_ptr<TableCell> mCppObj;
}

- (instancetype _Nonnull)initWithTableCell:(const std::shared_ptr<TableCell>)cppObj
{
    if (self = [super initWithContainer: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}


@end
