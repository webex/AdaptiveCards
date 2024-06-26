// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSTextWeightConvertor.h"

//cpp includes
#import "Enums.h"


#import "ACSFontWeightsConfig.h"
#import "HostConfig.h"


@implementation  ACSFontWeightsConfig {
    std::shared_ptr<FontWeightsConfig> mCppObj;
}

- (instancetype _Nonnull)initWithFontWeightsConfig:(const std::shared_ptr<FontWeightsConfig>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSNumber * _Nullable)getDefaultFontWeight:(enum ACSTextWeight)weight
{
    auto weightCpp = [ACSTextWeightConvertor convertObj:weight];
 
    auto getDefaultFontWeightCpp = mCppObj->GetDefaultFontWeight(weightCpp);
    return [NSNumber numberWithUnsignedInt:getDefaultFontWeightCpp];

}

- (NSNumber * _Nullable)getFontWeight:(enum ACSTextWeight)weight
{
    auto weightCpp = [ACSTextWeightConvertor convertObj:weight];
 
    auto getFontWeightCpp = mCppObj->GetFontWeight(weightCpp);
    return [NSNumber numberWithUnsignedInt:getFontWeightCpp];

}

- (void)setFontWeight:(enum ACSTextWeight)weight value:(NSNumber * _Nonnull)value
{
    auto weightCpp = [ACSTextWeightConvertor convertObj:weight];
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetFontWeight(weightCpp,valueCpp);
    
}


@end
