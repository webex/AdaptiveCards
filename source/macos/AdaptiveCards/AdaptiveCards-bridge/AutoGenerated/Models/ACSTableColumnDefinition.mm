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

- (ACSHorizontalAlignment _Nullable)getHorizontalCellContentAlignment
{
 
    auto getHorizontalCellContentAlignmentCpp = mCppObj->GetHorizontalCellContentAlignment();
    return [ACSHorizontalAlignmentConvertor convertCpp:getHorizontalCellContentAlignmentCpp];

}

- (void)setHorizontalCellContentAlignment:(enum ACSHorizontalAlignment _Nullable)value
{
    auto valueCpp = [ACSHorizontalAlignmentConvertor convertObj:value];
 
    mCppObj->SetHorizontalCellContentAlignment(valueCpp);
    
}

- (ACSVerticalContentAlignment _Nullable)getVerticalCellContentAlignment
{
 
    auto getVerticalCellContentAlignmentCpp = mCppObj->GetVerticalCellContentAlignment();
    return [ACSVerticalContentAlignmentConvertor convertCpp:getVerticalCellContentAlignmentCpp];

}

- (void)setVerticalCellContentAlignment:(enum ACSVerticalContentAlignment _Nullable)value
{
    auto valueCpp = [ACSVerticalContentAlignmentConvertor convertObj:value];
 
    mCppObj->SetVerticalCellContentAlignment(valueCpp);
    
}

- (NSNumber * _Nullable)getWidth
{
 
    auto getWidthCpp = mCppObj->GetWidth();
    return [NSNumber numberWithUnsignedInt:getWidthCpp];

}

- (void)setWidth:(NSNumber * _Nullable)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetWidth(valueCpp);
    
}

- (NSNumber * _Nullable)getPixelWidth
{
 
    auto getPixelWidthCpp = mCppObj->GetPixelWidth();
    return [NSNumber numberWithUnsignedInt:getPixelWidthCpp];

}

- (void)setPixelWidth:(NSNumber * _Nullable)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetPixelWidth(valueCpp);
    
}


@end
