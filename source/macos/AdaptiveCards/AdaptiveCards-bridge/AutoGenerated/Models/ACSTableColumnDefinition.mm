// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSHorizontalAlignmentConvertor.h"
#import "ACSVerticalContentAlignmentConvertor.h"

//cpp includes
#import "Enums.h"


#import "ACSTableColumnDefinition.h"
#import "TableColumnDefinition.h"



@implementation  ACSTableColumnDefinition {
    std::shared_ptr<TableColumnDefinition> mCppObj;
}

- (instancetype _Nonnull)initWithTableColumnDefinition:(const std::shared_ptr<TableColumnDefinition>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (ACSHorizontalAlignment)getHorizontalCellContentAlignment
{
 
    auto getHorizontalCellContentAlignmentCpp = mCppObj->GetHorizontalCellContentAlignment();
    return getHorizontalCellContentAlignmentCpp.has_value() ? [ACSHorizontalAlignmentConvertor convertCpp:getHorizontalCellContentAlignmentCpp.value_or(AdaptiveCards::HorizontalAlignment::Left)] : ACSHorizontalAlignmentNil;

}

- (void)setHorizontalCellContentAlignment:(enum ACSHorizontalAlignment)value
{
    auto valueCpp = [ACSHorizontalAlignmentConvertor convertObj:value];
 
    mCppObj->SetHorizontalCellContentAlignment(valueCpp);
    
}

- (ACSVerticalContentAlignment)getVerticalCellContentAlignment
{
 
    auto getVerticalCellContentAlignmentCpp = mCppObj->GetVerticalCellContentAlignment();
    return getVerticalCellContentAlignmentCpp.has_value() ? [ACSVerticalContentAlignmentConvertor convertCpp:getVerticalCellContentAlignmentCpp.value_or(AdaptiveCards::VerticalContentAlignment::Top)] : ACSVerticalContentAlignmentNil;

}

- (void)setVerticalCellContentAlignment:(enum ACSVerticalContentAlignment)value
{
    auto valueCpp = [ACSVerticalContentAlignmentConvertor convertObj:value];
 
    mCppObj->SetVerticalCellContentAlignment(valueCpp);
    
}

- (NSNumber * _Nullable)getWidth
{
 
    auto getWidthCpp = mCppObj->GetWidth();
    return getWidthCpp.has_value() ? [NSNumber numberWithUnsignedInt:getWidthCpp.value_or(0)] : NULL;

}

- (void)setWidth:(NSNumber * _Nullable)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetWidth(valueCpp);
    
}

- (NSNumber * _Nullable)getPixelWidth
{
 
    auto getPixelWidthCpp = mCppObj->GetPixelWidth();
    return getPixelWidthCpp.has_value() ? [NSNumber numberWithUnsignedInt:getPixelWidthCpp.value_or(0)] : NULL;

}

- (void)setPixelWidth:(NSNumber * _Nullable)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetPixelWidth(valueCpp);
    
}


@end
