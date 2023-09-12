// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSWebexData.h"
#import "WebexData.h"
#import "ACSCardWidthConvertor.h"



@implementation  ACSWebexData {
    std::shared_ptr<WebexData> mCppObj;
}

- (instancetype _Nonnull)initWithWebexData:(const std::shared_ptr<WebexData>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (ACSCardWidth)getCardWidth
{
    auto getCardWidthCpp = mCppObj->GetCardWidth();
    return [ACSCardWidthConvertor convertCpp:getCardWidthCpp];

}

- (void)setCardWidth:(enum ACSCardWidth)value
{
    auto valueCpp = [ACSCardWidthConvertor convertObj:value];
 
    mCppObj->SetCardWidth(valueCpp);
    
}


@end
