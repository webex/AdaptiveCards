// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSDateTimePreparser.h"
#import "ACSFontTypeConvertor.h"
#import "ACSForegroundColorConvertor.h"
#import "ACSParseContext.h"
#import "ACSTextSizeConvertor.h"
#import "ACSTextWeightConvertor.h"

//cpp includes
#import "DateTimePreparser.h"
#import "Enums.h"
#import "json.h"


#import "ACSTextElementProperties.h"
#import "TextElementProperties.h"


@implementation  ACSTextElementProperties {
    std::shared_ptr<TextElementProperties> mCppObj;
}

- (instancetype _Nonnull)initWithTextElementProperties:(const std::shared_ptr<TextElementProperties>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getText
{
 
    auto getTextCpp = mCppObj->GetText();
    return [NSString stringWithUTF8String:getTextCpp.c_str()];

}

- (void)setText:(NSString * _Nonnull)value
{
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetText(valueCpp);
    
}

- (ACSDateTimePreparser * _Nullable)getTextForDateParsing
{
 
//    auto getTextForDateParsingCpp = mCppObj->GetTextForDateParsing();
//    return [[ACSDateTimePreparser alloc] initWithDateTimePreparser:getTextForDateParsingCpp];
    return [[ACSDateTimePreparser alloc] init];
}

- (ACSTextSize _Nullable)getTextSize
{
 
    auto getTextSizeCpp = mCppObj->GetTextSize();
    return [ACSTextSizeConvertor convertCpp:getTextSizeCpp];

}

- (void)setTextSize:(enum ACSTextSize _Nullable)value
{
    auto valueCpp = [ACSTextSizeConvertor convertObj:value];
 
    mCppObj->SetTextSize(valueCpp);
    
}

- (ACSTextWeight _Nullable)getTextWeight
{
 
    auto getTextWeightCpp = mCppObj->GetTextWeight();
    return [ACSTextWeightConvertor convertCpp:getTextWeightCpp];

}

- (void)setTextWeight:(enum ACSTextWeight _Nullable)value
{
    auto valueCpp = [ACSTextWeightConvertor convertObj:value];
 
    mCppObj->SetTextWeight(valueCpp);
    
}

- (ACSFontType _Nullable)getFontType
{
 
    auto getFontTypeCpp = mCppObj->GetFontType();
    return [ACSFontTypeConvertor convertCpp:getFontTypeCpp];

}

- (void)setFontType:(enum ACSFontType _Nullable)value
{
    auto valueCpp = [ACSFontTypeConvertor convertObj:value];
 
    mCppObj->SetFontType(valueCpp);
    
}

- (ACSForegroundColor _Nullable)getTextColor
{
 
    auto getTextColorCpp = mCppObj->GetTextColor();
    return [ACSForegroundColorConvertor convertCpp:getTextColorCpp];

}

- (void)setTextColor:(enum ACSForegroundColor _Nullable)value
{
    auto valueCpp = [ACSForegroundColorConvertor convertObj:value];
 
    mCppObj->SetTextColor(valueCpp);
    
}

- (bool _Nullable)getIsSubtle
{
 
    auto getIsSubtleCpp = mCppObj->GetIsSubtle();
    return getIsSubtleCpp;

}

- (void)setIsSubtle:(bool _Nullable)value
{
    auto valueCpp = value;
 
    mCppObj->SetIsSubtle(valueCpp);
    
}

- (void)setLanguage:(NSString * _Nonnull)value
{
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetLanguage(valueCpp);
    
}

- (NSString * _Nullable)getLanguage
{
 
    auto getLanguageCpp = mCppObj->GetLanguage();
    return [NSString stringWithUTF8String:getLanguageCpp.c_str()];

}


@end
