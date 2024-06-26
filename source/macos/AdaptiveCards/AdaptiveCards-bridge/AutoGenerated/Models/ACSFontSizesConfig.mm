// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSTextSizeConvertor.h"

//cpp includes
#import "Enums.h"


#import "ACSFontSizesConfig.h"
#import "HostConfig.h"


@implementation  ACSFontSizesConfig {
    std::shared_ptr<FontSizesConfig> mCppObj;
}

- (instancetype _Nonnull)initWithFontSizesConfig:(const std::shared_ptr<FontSizesConfig>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSNumber * _Nullable)getDefaultFontSize:(enum ACSTextSize)size
{

    auto sizeCpp = [ACSTextSizeConvertor convertObj:size];
 
    auto getDefaultFontSizeCpp = mCppObj->GetDefaultFontSize(sizeCpp);
    return [NSNumber numberWithUnsignedInt:getDefaultFontSizeCpp];

}

- (NSNumber * _Nullable)getFontSize:(enum ACSTextSize)size
{
    auto sizeCpp = [ACSTextSizeConvertor convertObj:size];
 
    auto getFontSizeCpp = mCppObj->GetFontSize(sizeCpp);
    return [NSNumber numberWithUnsignedInt:getFontSizeCpp];

}

- (void)setFontSize:(enum ACSTextSize)size value:(NSNumber * _Nonnull)value
{
    auto sizeCpp = [ACSTextSizeConvertor convertObj:size];
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetFontSize(sizeCpp,valueCpp);
    
}


@end
