// DO NOT EDIT - Auto generated
// Generated with objc_convertor_enum.j2

#import "ACSTextStyleConvertor.h"
#import "Enums.h"
// #import "ConversionUtils.h"
#import "SwiftInterfaceHeader.h"
#import "ACSTextStyle.h"

@implementation ACSTextStyleConvertor


+(enum ACSTextStyle) convertCpp:(AdaptiveCards::TextStyle) textStyleCpp
{
  switch(textStyleCpp)
  {
    case AdaptiveCards::TextStyle::Default:
      return ACSTextStyle::ACSTextStyleDefault;
    case AdaptiveCards::TextStyle::Heading:
      return ACSTextStyle::ACSTextStyleHeading;
  }
}


+(AdaptiveCards::TextStyle) convertObj:(enum ACSTextStyle) textStyleObjc
{
  switch(textStyleObjc)
  {
    case ACSTextStyle::ACSTextStyleDefault:
      return AdaptiveCards::TextStyle::Default;
    case ACSTextStyle::ACSTextStyleHeading:
      return AdaptiveCards::TextStyle::Heading;
  }
}

@end
