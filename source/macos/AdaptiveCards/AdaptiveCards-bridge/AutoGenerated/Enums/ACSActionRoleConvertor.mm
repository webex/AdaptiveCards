// DO NOT EDIT - Auto generated
// Generated with objc_convertor_enum.j2

#import "ACSActionRoleConvertor.h"
#import "Enums.h"
// #import "ConversionUtils.h"
#import "SwiftInterfaceHeader.h"
#import "ACSActionRole.h"

@implementation ACSActionRoleConvertor


+(enum ACSActionRole) convertCpp:(AdaptiveCards::ActionRole) actionRoleCpp
{
  switch(actionRoleCpp)
  {
	case AdaptiveCards::ActionRole::Button:
	  return ACSActionRole::ACSActionRoleButton;
	case AdaptiveCards::ActionRole::Link:
	  return ACSActionRole::ACSActionRoleLink;
	case AdaptiveCards::ActionRole::Tab:
	  return ACSActionRole::ACSActionRoleTab;
	case AdaptiveCards::ActionRole::Menu:
	  return ACSActionRole::ACSActionRoleMenu;
	case AdaptiveCards::ActionRole::MenuItem:
	  return ACSActionRole::ACSActionRoleMenuItem;
  }
}


+(AdaptiveCards::ActionRole) convertObj:(enum ACSActionRole) actionRoleObjc
{
  switch(actionRoleObjc)
  {
	case ACSActionRole::ACSActionRoleButton:
	  return AdaptiveCards::ActionRole::Button;
	case ACSActionRole::ACSActionRoleLink:
	  return AdaptiveCards::ActionRole::Link;
	case ACSActionRole::ACSActionRoleTab:
	  return AdaptiveCards::ActionRole::Tab;
	case ACSActionRole::ACSActionRoleMenu:
	  return AdaptiveCards::ActionRole::Menu;
	case ACSActionRole::ACSActionRoleMenuItem:
	  return AdaptiveCards::ActionRole::MenuItem;
  }
}

@end
