// DO NOT EDIT - Auto generated
// Generated with objc_convertor.j2

//cpp includes 
#import "HostConfig.h"

#import "ACSTableConfigConvertor.h"
#import "SwiftInterfaceHeader.h"
// #import "ConversionUtils.h"

@implementation ACSTableConfigConvertor 

+(ACSTableConfig *) convertCpp:(const AdaptiveCards::TableConfig& )tableConfigCpp
{ 
     @autoreleasepool { 
 
        ACSTableConfig*  tableConfigCocoa = [[ ACSTableConfig  alloc] initWithCellSpacing: [NSNumber numberWithUnsignedInt:tableConfigCpp.cellSpacing] ];
        return  tableConfigCocoa;
   }
}

+(AdaptiveCards::TableConfig) convertObj:(ACSTableConfig *)tableConfigObjc {
  AdaptiveCards::TableConfig tableConfigCpp;
  tableConfigCpp.cellSpacing = [tableConfigObjc.cellSpacing unsignedIntValue];
  return  tableConfigCpp;
}

@end 
