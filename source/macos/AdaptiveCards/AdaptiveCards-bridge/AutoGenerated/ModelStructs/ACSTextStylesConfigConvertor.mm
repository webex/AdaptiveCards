// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"

#import "ACSTextStylesConfigConvertor.h"
#import "ACSTextStyleConfigConvertor.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSTextStylesConfigConvertor 

+(ACSTextStylesConfig *) convertCpp:(const AdaptiveCards::TextStylesConfig& )textStylesConfigCpp
{ 
     @autoreleasepool { 
 
        ACSTextStylesConfig*  textStylesConfigCocoa = [[ ACSTextStylesConfig  alloc] initWithHeading: [ACSTextStyleConfigConvertor convertCpp:textStylesConfigCpp.heading] 
        columnHeader: [ACSTextStyleConfigConvertor convertCpp:textStylesConfigCpp.columnHeader]];
        return  textStylesConfigCocoa;
   }
}

+(AdaptiveCards::TextStylesConfig) convertObj:(ACSTextStylesConfig *)textStylesConfigObjc {
  AdaptiveCards::TextStylesConfig textStylesConfigCpp;
  textStylesConfigCpp.heading = [ACSTextStyleConfigConvertor convertObj:textStylesConfigObjc.heading];
  textStylesConfigCpp.columnHeader = [ACSTextStyleConfigConvertor convertObj:textStylesConfigObjc.columnHeader];
  return  textStylesConfigCpp;
}

@end 
