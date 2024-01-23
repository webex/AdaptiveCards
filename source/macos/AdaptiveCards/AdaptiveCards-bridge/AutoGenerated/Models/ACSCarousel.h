// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSCarousel_IMPORTED
#define ACSCarousel_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "Carousel.h"
using namespace AdaptiveCards;
#endif

#import "ACSCarouselOrientation.h"

#import "ACSCollectionCoreElement.h"
#import "ACSCarouselPage.h"

@class ACSCarouselPage;

enum ACSCarouselOrientation: NSUInteger;


@interface ACSCarousel : ACSCollectionCoreElement
#ifdef __cplusplus
- (instancetype _Nonnull)initWithCarousel:(const std::shared_ptr<Carousel>)cppObj;
#endif

- (NSArray<ACSCarouselPage *> * _Nonnull)getPages;
- (void)setPages:(NSArray<ACSCarouselPage *>* _Nonnull)value;
- (NSString * _Nullable)getHeightInPixels;
- (void)setHeightInPixels:(NSString * _Nonnull)value;
- (NSNumber * _Nullable)getTimer;
- (void)setTimer:(NSNumber * _Nullable)value;
- (NSNumber * _Nullable)getInitialPage;
- (void)setInitialPage:(NSNumber * _Nullable)value;
- (ACSCarouselOrientation)getOrientation;
- (void)setOrientation:(enum ACSCarouselOrientation)value;
- (bool)getAutoLoop;
- (void)setAutoLoop:(bool)value;

@end
#endif
