// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSContentSource.h"

//cpp includes


#import "ACSMediaSource.h"
#import "MediaSource.h"


@implementation  ACSMediaSource {
    std::shared_ptr<MediaSource> mCppObj;
}

- (instancetype _Nonnull)initWithMediaSource:(const std::shared_ptr<MediaSource>)cppObj
{
    if (self = [super initWithContentSource: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}



@end
