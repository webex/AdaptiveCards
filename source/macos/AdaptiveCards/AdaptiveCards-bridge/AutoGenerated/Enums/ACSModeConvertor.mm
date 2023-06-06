// DO NOT EDIT - Auto generated
// Generated with objc_convertor_enum.j2

#import "ACSModeConvertor.h"
#import "Enums.h"
// #import "ConversionUtils.h"
#import "SwiftInterfaceHeader.h"
#import "ACSMode.h"

@implementation ACSModeConvertor


+(enum ACSMode) convertCpp:(AdaptiveCards::Mode) modeCpp
{
  switch(modeCpp)
  {
    case AdaptiveCards::Mode::Primary:
      return ACSMode::ACSModePrimary;
    case AdaptiveCards::Mode::Secondary:
      return ACSMode::ACSModeSecondary;
  }
}


+(AdaptiveCards::Mode) convertObj:(enum ACSMode) modeObjc
{
  switch(modeObjc)
  {
    case ACSMode::ACSModePrimary:
      return AdaptiveCards::Mode::Primary;
    case ACSMode::ACSModeSecondary:
      return AdaptiveCards::Mode::Secondary;
  }
}

@end
