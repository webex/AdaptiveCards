// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSCarouselOrientationConvertor.h"
#import "ACSCarouselPage.h"

//cpp includes
#import "Enums.h"
#import "CarouselPage.h"

#import "ACSCarousel.h"
#import "Carousel.h"



@implementation  ACSCarousel {
    std::shared_ptr<Carousel> mCppObj;
}


- (instancetype _Nonnull)initWithCarousel:(const std::shared_ptr<Carousel>)cppObj;
{
    if (self = [super initWithCollectionCoreElement: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSArray<ACSCarouselPage *> * _Nonnull)getPages
{
 
    auto getPagesCpp = mCppObj->GetPages();
    NSMutableArray*  objList = [NSMutableArray new];
    for (const auto& item: getPagesCpp)
	{
		[objList addObject: [[ACSCarouselPage alloc] initWithCarouselPage:item]];
	}
    return objList;


}

- (void)setPages:(NSArray<ACSCarouselPage *>* _Nonnull)value
{
	// Do nothing.
}

- (NSString * _Nullable)getHeightInPixels
{
 
    auto getHeightInPixelsCpp = mCppObj->GetHeightInPixels();
    return [NSString stringWithUTF8String:getHeightInPixelsCpp.c_str()];

}

- (void)setHeightInPixels:(NSString * _Nonnull)value
{
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetHeightInPixels(valueCpp);
    
}

- (NSNumber * _Nullable)getTimer
{
 
    auto getTimerCpp = mCppObj->GetTimer();
    return getTimerCpp.has_value() ? [NSNumber numberWithUnsignedLongLong:getTimerCpp.value_or(0)] : NULL;

}

- (void)setTimer:(NSNumber * _Nullable)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetTimer(valueCpp);
    
}

- (NSNumber * _Nullable)getInitialPage
{
 
    auto getInitialPageCpp = mCppObj->GetInitialPage();
    return getInitialPageCpp.has_value() ? [NSNumber numberWithUnsignedInt:getInitialPageCpp.value_or(0)] : NULL;

}

- (void)setInitialPage:(NSNumber * _Nullable)value
{
    auto valueCpp = [value unsignedIntValue];
 
    mCppObj->SetInitialPage(valueCpp);
    
}

- (ACSCarouselOrientation)getOrientation
{
 
    auto getOrientationCpp = mCppObj->GetOrientation();
    return getOrientationCpp.has_value() ? [ACSCarouselOrientationConvertor convertCpp:getOrientationCpp.value_or(AdaptiveCards::CarouselOrientation::Horizontal)] : ACSCarouselOrientationNil;

}

- (void)setOrientation:(enum ACSCarouselOrientation)value
{
    auto valueCpp = [ACSCarouselOrientationConvertor convertObj:value];
 
    mCppObj->SetOrientation(valueCpp);
    
}

- (bool)getAutoLoop
{
 
    auto getAutoLoopCpp = mCppObj->GetAutoLoop();
    return getAutoLoopCpp.value_or(false);

}

- (void)setAutoLoop:(bool)value
{
		
    auto valueCpp = value;
 
    mCppObj->setAutoLoop(valueCpp);
    
}

@end
