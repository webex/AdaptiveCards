// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"
#import "Enums.h"

#import "ACSFactSetTextConfigConvertor.h"
#import "ACSFontTypeConvertor.h"
#import "ACSForegroundColorConvertor.h"
#import "ACSTextSizeConvertor.h"
#import "ACSTextWeightConvertor.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSFactSetTextConfigConvertor 

+(ACSFactSetTextConfig *) convertCpp:(const AdaptiveCards::FactSetTextConfig& )factSetTextConfigCpp
{ 
     @autoreleasepool { 
 
        ACSFactSetTextConfig*  factSetTextConfigCocoa = [[ ACSFactSetTextConfig  alloc] initWithWrap: factSetTextConfigCpp.wrap 
        maxWidth: [NSNumber numberWithUnsignedInt:factSetTextConfigCpp.maxWidth]
        weight: [ACSTextWeightConvertor convertCpp:factSetTextConfigCpp.weight]
        size: [ACSTextSizeConvertor convertCpp:factSetTextConfigCpp.size]
        isSubtle: factSetTextConfigCpp.isSubtle
        color: [ACSForegroundColorConvertor convertCpp:factSetTextConfigCpp.color]
        fontType: [ACSFontTypeConvertor convertCpp:factSetTextConfigCpp.fontType]];
        return  factSetTextConfigCocoa;
   }
}

+(AdaptiveCards::FactSetTextConfig) convertObj:(ACSFactSetTextConfig *)factSetTextConfigObjc {
  AdaptiveCards::FactSetTextConfig factSetTextConfigCpp;
  factSetTextConfigCpp.wrap = factSetTextConfigObjc.wrap;
  factSetTextConfigCpp.maxWidth = [factSetTextConfigObjc.maxWidth unsignedIntValue];
  factSetTextConfigCpp.weight = [ACSTextWeightConvertor convertObj:factSetTextConfigObjc.weight];
  factSetTextConfigCpp.size = [ACSTextSizeConvertor convertObj:factSetTextConfigObjc.size];
  factSetTextConfigCpp.isSubtle = factSetTextConfigObjc.isSubtle;
  factSetTextConfigCpp.color = [ACSForegroundColorConvertor convertObj:factSetTextConfigObjc.color];
  factSetTextConfigCpp.fontType = [ACSFontTypeConvertor convertObj:factSetTextConfigObjc.fontType];
  return  factSetTextConfigCpp;
}

@end 
