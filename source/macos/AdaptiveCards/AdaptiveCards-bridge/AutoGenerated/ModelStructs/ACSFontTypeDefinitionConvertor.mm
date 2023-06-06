// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"

#import "ACSFontTypeDefinitionConvertor.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSFontTypeDefinitionConvertor 

+(ACSFontTypeDefinition *) convertCpp:(const AdaptiveCards::FontTypeDefinition& )fontTypeDefinitionCpp
{ 
     @autoreleasepool { 
 
        ACSFontTypeDefinition*  fontTypeDefinitionCocoa = [[ ACSFontTypeDefinition  alloc] initWithFontFamily: [NSString stringWithUTF8String:fontTypeDefinitionCpp.fontFamily.c_str()]
		// old changes 
		fontSizes: [[ACSFontSizesConfig alloc] init]
        fontWeights: [[ACSFontWeightsConfig alloc] init]];
		// new codegen
        // fontSizes: [NSNumber numberWithInt:fontTypeDefinitionCpp.fontSizes]
        // fontWeights: [NSNumber numberWithInt:fontTypeDefinitionCpp.fontWeights]];
        return  fontTypeDefinitionCocoa;
   }
}

+(AdaptiveCards::FontTypeDefinition) convertObj:(ACSFontTypeDefinition *)fontTypeDefinitionObjc {
  AdaptiveCards::FontTypeDefinition fontTypeDefinitionCpp;
  fontTypeDefinitionCpp.fontFamily = std::string([fontTypeDefinitionObjc.fontFamily UTF8String]);
	// old change
//  fontTypeDefinitionCpp.fontSizes = // NEED TO INSERT CODE //;
//  fontTypeDefinitionCpp.fontWeights = // NEED TO INSERT CODE //;
	// new codegen
	// fontTypeDefinitionCpp.fontSizes = [fontTypeDefinitionObjc.fontSizes intValue];
  	// fontTypeDefinitionCpp.fontWeights = [fontTypeDefinitionObjc.fontWeights intValue];
  return  fontTypeDefinitionCpp;
}

@end 
