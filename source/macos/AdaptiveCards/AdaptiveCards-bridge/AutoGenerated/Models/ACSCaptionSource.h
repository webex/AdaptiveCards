// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSCaptionSource_IMPORTED
#define ACSCaptionSource_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "CaptionSource.h"
using namespace AdaptiveCards;
#endif


#import "ACSContentSource.h"



@interface ACSCaptionSource : ACSContentSource
#ifdef __cplusplus
- (instancetype _Nonnull)initWithCaptionSource:(const std::shared_ptr<CaptionSource>)cppObj;
#endif

- (NSString * _Nullable)getLabel;
- (void)setLabel:(NSString * _Nonnull)value;


@end
#endif