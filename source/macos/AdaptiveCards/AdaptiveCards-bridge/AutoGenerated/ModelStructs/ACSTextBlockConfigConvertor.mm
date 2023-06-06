// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"

#import "ACSTextBlockConfigConvertor.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSTextBlockConfigConvertor 

+(ACSTextBlockConfig *) convertCpp:(const AdaptiveCards::TextBlockConfig& )textBlockConfigCpp
{ 
     @autoreleasepool { 
 
        ACSTextBlockConfig*  textBlockConfigCocoa = [[ ACSTextBlockConfig  alloc] initWithHeadingLevel: [NSNumber numberWithUnsignedInt:textBlockConfigCpp.headingLevel] ];
        return  textBlockConfigCocoa;
   }
}

+(AdaptiveCards::TextBlockConfig) convertObj:(ACSTextBlockConfig *)textBlockConfigObjc {
  AdaptiveCards::TextBlockConfig textBlockConfigCpp;
  textBlockConfigCpp.headingLevel = [textBlockConfigObjc.headingLevel unsignedIntValue];
  return  textBlockConfigCpp;
}

@end 
