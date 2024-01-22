// DO NOT EDIT - Auto generated
// Generated with objc_convertor_enum.j2

#import "ACSCarouselOrientationConvertor.h"
#import "Enums.h"
// #import "ConversionUtils.h"
#import "SwiftInterfaceHeader.h"
#import "ACSCarouselOrientation.h"

@implementation ACSCarouselOrientationConvertor


+(enum ACSCarouselOrientation) convertCpp:(AdaptiveCards::CarouselOrientation) carouselOrientationCpp
{
  switch(carouselOrientationCpp)
  {
	case AdaptiveCards::CarouselOrientation::Horizontal:
	  return ACSCarouselOrientation::ACSCarouselOrientationHorizontal;
	case AdaptiveCards::CarouselOrientation::Vertical:
	  return ACSCarouselOrientation::ACSCarouselOrientationVertical;
  }
}


+(AdaptiveCards::CarouselOrientation) convertObj:(enum ACSCarouselOrientation) carouselOrientationObjc
{
  switch(carouselOrientationObjc)
  {
	case ACSCarouselOrientation::ACSCarouselOrientationHorizontal:
	  return AdaptiveCards::CarouselOrientation::Horizontal;
	case ACSCarouselOrientation::ACSCarouselOrientationVertical:
	  return AdaptiveCards::CarouselOrientation::Vertical;
	default:
	  return AdaptiveCards::CarouselOrientation::Horizontal;
  }
}

@end
