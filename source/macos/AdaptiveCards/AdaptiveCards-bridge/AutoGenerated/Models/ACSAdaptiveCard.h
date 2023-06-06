// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSAdaptiveCard_IMPORTED
#define ACSAdaptiveCard_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "SharedAdaptiveCard.h"
using namespace AdaptiveCards;
#endif

#import "ACSAuthentication.h"
#import "ACSBackgroundImage.h"
#import "ACSBaseActionElement.h"
#import "ACSRefresh.h"
//#import "ACSRemoteResourceInformation.h"
#import "ACSCardElementType.h"
#import "ACSBaseCardElement.h"
#import "ACSContainerStyle.h"
#import "ACSHeightType.h"
#import "ACSInternalId.h"
#import "ACSVerticalContentAlignment.h"
#import "ACSAdaptiveCardParseWarning.h"





@class ACSAuthentication;
@class ACSBackgroundImage;
@class ACSBaseActionElement;
@class ACSFontTypesDefinition;
@class ACSBaseCardElement;
@class ACSInternalId;
@class ACSRefresh;
@class ACSRemoteResourceInformation;
@class ACSAdaptiveCardParseWarning;

enum ACSCardElementType: NSUInteger;
enum ACSContainerStyle: NSUInteger;
enum ACSHeightType: NSUInteger;
enum ACSVerticalContentAlignment: NSUInteger;


@interface ACSAdaptiveCard : NSObject

#ifdef __cplusplus
- (instancetype _Nonnull)initWithAdaptiveCard:(const std::shared_ptr<AdaptiveCard>)cppObj;
#endif

- (NSString * _Nullable)getVersion;
- (void)setVersion:(NSString * _Nonnull)value;
- (NSString * _Nullable)getFallbackText;
- (void)setFallbackText:(NSString * _Nonnull)value;
- (ACSBackgroundImage * _Nullable)getBackgroundImage;
- (void)setBackgroundImage:(ACSBackgroundImage * _Nonnull)value;
- (ACSRefresh * _Nullable)getRefresh;
- (void)setRefresh:(ACSRefresh * _Nonnull)value;
- (ACSAuthentication * _Nullable)getAuthentication;
- (void)setAuthentication:(ACSAuthentication * _Nonnull)value;
- (NSString * _Nullable)getSpeak;
- (void)setSpeak:(NSString * _Nonnull)value;
- (ACSContainerStyle)getStyle;
- (void)setStyle:(enum ACSContainerStyle)value;
- (NSString * _Nullable)getLanguage;
- (void)setLanguage:(NSString * _Nonnull)value;
- (ACSVerticalContentAlignment)getVerticalContentAlignment;
- (void)setVerticalContentAlignment:(enum ACSVerticalContentAlignment)value;
- (ACSHeightType)getHeight;
- (void)setHeight:(enum ACSHeightType)value;
- (NSNumber * _Nullable)getMinHeight;
- (void)setMinHeight:(NSNumber * _Nonnull)value;
- (bool)getRtl;
- (void)setRtl:(bool)value;
- (ACSBaseActionElement * _Nullable)getSelectAction;
- (void)setSelectAction:(ACSBaseActionElement * _Nonnull)action;
- (NSArray<ACSBaseCardElement *> * _Nonnull)getBody;
- (NSArray<ACSBaseActionElement *> * _Nonnull)getActions;
- (NSArray<ACSRemoteResourceInformation *> * _Nonnull)getResourceInformation;
- (ACSCardElementType)getElementType;
- (ACSInternalId * _Nullable)getInternalId;


@end
#endif
