// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSMedia_IMPORTED
#define ACSMedia_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "Media.h"
using namespace AdaptiveCards;
#endif

#import "ACSCaptionSource.h"
#import "ACSMediaSource.h"
// #import "ACSRemoteResourceInformation.h"



#import "ACSBaseCardElement.h"


@class ACSCaptionSource;
@class ACSMediaSource;
@class ACSRemoteResourceInformation;



@interface ACSMedia : ACSBaseCardElement

#ifdef __cplusplus
- (instancetype _Nonnull)initWithMedia:(const std::shared_ptr<Media>)cppObj;
#endif

- (NSString * _Nullable)getPoster;
- (void)setPoster:(NSString * _Nonnull)value;
- (NSString * _Nullable)getAltText;
- (void)setAltText:(NSString * _Nonnull)value;
- (NSArray<ACSMediaSource *> * _Nonnull)getSources;
- (NSArray<ACSCaptionSource *> * _Nonnull)getCaptionSources;
- (void)getResourceInformation:(NSArray<ACSRemoteResourceInformation *>* _Nonnull)resourceInfo;



@end
#endif
