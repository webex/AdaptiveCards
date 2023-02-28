// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"

#import "ACSFactSetConfigConvertor.h"
#import "ACSFactSetTextConfigConvertor.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSFactSetConfigConvertor 

+(ACSFactSetConfig *) convertCpp:(const AdaptiveCards::FactSetConfig& )factSetConfigCpp
{ 
     @autoreleasepool { 
 
        ACSFactSetConfig*  factSetConfigCocoa = [[ ACSFactSetConfig  alloc] initWithTitle: [ACSFactSetTextConfigConvertor convertCpp:factSetConfigCpp.title] 
        value: [ACSFactSetTextConfigConvertor convertCpp:factSetConfigCpp.value]
        spacing: [NSNumber numberWithUnsignedInt:factSetConfigCpp.spacing]];
        return  factSetConfigCocoa;
   }
}

+(AdaptiveCards::FactSetConfig) convertObj:(ACSFactSetConfig *)factSetConfigObjc {
  AdaptiveCards::FactSetConfig factSetConfigCpp;
  factSetConfigCpp.title = [ACSFactSetTextConfigConvertor convertObj:factSetConfigObjc.title];
  factSetConfigCpp.value = [ACSFactSetTextConfigConvertor convertObj:factSetConfigObjc.value];
  factSetConfigCpp.spacing = [factSetConfigObjc.spacing unsignedIntValue];
  return  factSetConfigCpp;
}

@end 
