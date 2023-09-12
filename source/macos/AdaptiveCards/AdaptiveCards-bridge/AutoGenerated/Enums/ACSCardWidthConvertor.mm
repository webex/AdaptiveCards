// DO NOT EDIT - Auto generated
// Generated with objc_convertor_enum.j2

#import "ACSCardWidthConvertor.h"
#import "Enums.h"
// #import "ConversionUtils.h"
#import "SwiftInterfaceHeader.h"
#import "ACSCardWidth.h"

@implementation ACSCardWidthConvertor


+(enum ACSCardWidth) convertCpp:(AdaptiveCards::CardWidth) cardWidthCpp
{
  switch(cardWidthCpp)
  {
    case AdaptiveCards::CardWidth::Auto:
      return ACSCardWidth::ACSCardWidthAuto;
    case AdaptiveCards::CardWidth::Short:
      return ACSCardWidth::ACSCardWidthShort;
    case AdaptiveCards::CardWidth::Medium:
        return ACSCardWidth::ACSCardWidthMedium;
    case AdaptiveCards::CardWidth::Large:
        return ACSCardWidth::ACSCardWidthLarge;
  }
}


+(AdaptiveCards::CardWidth) convertObj:(enum ACSCardWidth) cardWidthObjc
{
  switch(cardWidthObjc)
  {
    case ACSCardWidth::ACSCardWidthAuto:
      return AdaptiveCards::CardWidth::Auto;
    case ACSCardWidth::ACSCardWidthShort:
      return AdaptiveCards::CardWidth::Short;
    case ACSCardWidth::ACSCardWidthMedium:
      return AdaptiveCards::CardWidth::Medium;
    case ACSCardWidth::ACSCardWidthLarge:
      return AdaptiveCards::CardWidth::Large;
  }
}

@end
