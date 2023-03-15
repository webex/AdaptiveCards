// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSBackgroundImage.h"
#import "ACSBaseActionElement.h"
#import "ACSContainerBleedDirectionConvertor.h"
#import "ACSContainerStyleConvertor.h"
#import "ACSInternalId.h"
#import "ACSParseContext.h"
// #import "ACSValue.h"
#import "ACSVerticalContentAlignmentConvertor.h"

//cpp includes
#import "BackgroundImage.h"
#import "BaseActionElement.h"
#import "Enums.h"
#import "json.h"
#import "ParseContext.h"
#import "InternalId.h"


#import "ACSStyledCollectionElement.h"
#import "StyledCollectionElement.h"



@implementation  ACSStyledCollectionElement {
    std::shared_ptr<StyledCollectionElement> mCppObj;
}

- (instancetype _Nonnull)initWithStyledCollectionElement:(const std::shared_ptr<StyledCollectionElement>)cppObj
{
    if (self = [super initWithCollectionCoreElement: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (ACSContainerStyle)getStyle
{
 
    auto getStyleCpp = mCppObj->GetStyle();
    return [ACSContainerStyleConvertor convertCpp:getStyleCpp];

}

- (void)setStyle:(enum ACSContainerStyle)value
{
    auto valueCpp = [ACSContainerStyleConvertor convertObj:value];
 
    mCppObj->SetStyle(valueCpp);
    
}

- (ACSVerticalContentAlignment _Nullable)getVerticalContentAlignment
{
 
    auto getVerticalContentAlignmentCpp = mCppObj->GetVerticalContentAlignment();
    return [ACSVerticalContentAlignmentConvertor convertCpp:getVerticalContentAlignmentCpp];

}

- (void)setVerticalContentAlignment:(enum ACSVerticalContentAlignment _Nullable)value
{
    auto valueCpp = [ACSVerticalContentAlignmentConvertor convertObj:value];
 
    mCppObj->SetVerticalContentAlignment(valueCpp);
    
}

- (bool)getPadding
{
 
    auto getPaddingCpp = mCppObj->GetPadding();
    return getPaddingCpp;

}

- (void)setPadding:(bool)value
{
    auto valueCpp = value;
 
    mCppObj->SetPadding(valueCpp);
    
}

- (bool)getBleed
{
 
    auto getBleedCpp = mCppObj->GetBleed();
    return getBleedCpp;

}

- (void)setBleed:(bool)value
{
    auto valueCpp = value;
 
    mCppObj->SetBleed(valueCpp);
    
}

- (bool)getCanBleed
{
 
    auto getCanBleedCpp = mCppObj->GetCanBleed();
    return getCanBleedCpp;

}

- (ACSContainerBleedDirection)getBleedDirection
{
 
    auto getBleedDirectionCpp = mCppObj->GetBleedDirection();
    return [ACSContainerBleedDirectionConvertor convertCpp:getBleedDirectionCpp];

}

- (void)configForContainerStyle:(ACSParseContext * _Nonnull)context
{
    // auto contextCpp = [ACSParseContextConvertor convertObj:context];
 
    // mCppObj->ConfigForContainerStyle(contextCpp);
    
}

- (void)setParentalId:(ACSInternalId * _Nonnull)id
{
    // auto idCpp = [ACSInternalIdConvertor convertObj:id];
 
    // mCppObj->SetParentalId(idCpp);
    
}

- (ACSInternalId * _Nullable)getParentalId
{
 
    // auto getParentalIdCpp = mCppObj->GetParentalId();
    // return [ACSInternalIdConvertor convertCpp:getParentalIdCpp];
    return [[ACSInternalId alloc] init];

}

- (ACSBaseActionElement * _Nullable)getSelectAction
{
 
    auto getSelectActionCpp = mCppObj->GetSelectAction();
    return [BridgeConverter convertFromBaseActionElement:getSelectActionCpp];

}

- (void)setSelectAction:(ACSBaseActionElement * _Nonnull)action
{
    // auto actionCpp = [ACSBaseActionElementConvertor convertObj:action];
 
    // mCppObj->SetSelectAction(actionCpp);
    
}

- (ACSBackgroundImage * _Nullable)getBackgroundImage
{
 
    auto getBackgroundImageCpp = mCppObj->GetBackgroundImage();
    if (getBackgroundImageCpp)
        return [[ACSBackgroundImage alloc] initWithBackgroundImage:getBackgroundImageCpp];
    return NULL;

}

- (void)setBackgroundImage:(ACSBackgroundImage * _Nonnull)value
{
//    auto valueCpp = // NEED TO INSERT CODE //;
//
//    mCppObj->SetBackgroundImage(valueCpp);
//
}

- (NSNumber * _Nullable)getMinHeight
{
 
    auto getMinHeightCpp = mCppObj->GetMinHeight();
    return [NSNumber numberWithUnsignedInt:getMinHeightCpp];

}

- (void)setMinHeight:(NSNumber * _Nonnull)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetMinHeight(valueCpp);
    
}



@end
