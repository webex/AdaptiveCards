// DO NOT EDIT - Auto generated
// Generated with objc_convertor_enum.j2

#import "ACSChoiceSetStyleConvertor.h"
#import "Enums.h"
// #import "ConversionUtils.h"
#import "SwiftInterfaceHeader.h"
#import "ACSChoiceSetStyle.h"

@implementation ACSChoiceSetStyleConvertor


+(enum ACSChoiceSetStyle) convertCpp:(AdaptiveCards::ChoiceSetStyle) choiceSetStyleCpp
{
  switch(choiceSetStyleCpp)
  {
    case AdaptiveCards::ChoiceSetStyle::Compact:
      return ACSChoiceSetStyle::ACSChoiceSetStyleCompact;
    case AdaptiveCards::ChoiceSetStyle::Expanded:
      return ACSChoiceSetStyle::ACSChoiceSetStyleExpanded;
    case AdaptiveCards::ChoiceSetStyle::Filtered:
      return ACSChoiceSetStyle::ACSChoiceSetStyleFiltered;
  }
}


+(AdaptiveCards::ChoiceSetStyle) convertObj:(enum ACSChoiceSetStyle) choiceSetStyleObjc
{
  switch(choiceSetStyleObjc)
  {
    case ACSChoiceSetStyle::ACSChoiceSetStyleCompact:
      return AdaptiveCards::ChoiceSetStyle::Compact;
    case ACSChoiceSetStyle::ACSChoiceSetStyleExpanded:
      return AdaptiveCards::ChoiceSetStyle::Expanded;
    case ACSChoiceSetStyle::ACSChoiceSetStyleFiltered:
      return AdaptiveCards::ChoiceSetStyle::Filtered;
  }
}

@end
