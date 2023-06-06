// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"
#import "Enums.h"

#import "ACSTextStyleConfigConvertor.h"
#import "ACSFontTypeConvertor.h"
#import "ACSForegroundColorConvertor.h"
#import "ACSTextSizeConvertor.h"
#import "ACSTextWeightConvertor.h"
#import "ACSFontType.h"
#import "ACSForegroundColor.h"
#import "ACSTextSize.h"
#import "ACSTextWeight.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSTextStyleConfigConvertor 

+(ACSTextStyleConfig *) convertCpp:(const AdaptiveCards::TextStyleConfig& )textStyleConfigCpp
{ 
     @autoreleasepool { 
 
        ACSTextStyleConfig*  textStyleConfigCocoa = [[ ACSTextStyleConfig  alloc] initWithWeight: [ACSTextWeightConvertor convertCpp:textStyleConfigCpp.weight] 
        size: [ACSTextSizeConvertor convertCpp:textStyleConfigCpp.size]
        isSubtle: textStyleConfigCpp.isSubtle
        color: [ACSForegroundColorConvertor convertCpp:textStyleConfigCpp.color]
        fontType: [ACSFontTypeConvertor convertCpp:textStyleConfigCpp.fontType]];
        return  textStyleConfigCocoa;
   }
}

+(AdaptiveCards::TextStyleConfig) convertObj:(ACSTextStyleConfig *)textStyleConfigObjc {
  AdaptiveCards::TextStyleConfig textStyleConfigCpp;
  textStyleConfigCpp.weight = [ACSTextWeightConvertor convertObj:textStyleConfigObjc.weight];
  textStyleConfigCpp.size = [ACSTextSizeConvertor convertObj:textStyleConfigObjc.size];
  textStyleConfigCpp.isSubtle = textStyleConfigObjc.isSubtle;
  textStyleConfigCpp.color = [ACSForegroundColorConvertor convertObj:textStyleConfigObjc.color];
  textStyleConfigCpp.fontType = [ACSFontTypeConvertor convertObj:textStyleConfigObjc.fontType];
  return  textStyleConfigCpp;
}

@end 
