// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSCaptionSource.h"
#import "CaptionSource.h"



@implementation  ACSCaptionSource {
    std::shared_ptr<CaptionSource> mCppObj;
}

- (instancetype _Nonnull)initWithCaptionSource:(const std::shared_ptr<CaptionSource>)cppObj
{
    if (self = [super initWithContentSource: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getLabel
{
 
    auto getLabelCpp = mCppObj->GetLabel();
    return [NSString stringWithUTF8String:getLabelCpp.c_str()];

}

- (void)setLabel:(NSString * _Nonnull)value
{
		
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetLabel(valueCpp);
    
}




@end