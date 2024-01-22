// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSBaseActionElement_IMPORTED
#define ACSBaseActionElement_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "BaseActionElement.h"
using namespace AdaptiveCards;
#endif

//#import "ACSRemoteResourceInformation.h"
#import "ACSActionType.h"
#import "ACSMode.h"
#import "ACSActionRole.h"

#import "ACSBaseElement.h"
@class ACSBaseElement;
@class ACSRemoteResourceInformation;

enum ACSActionType: NSUInteger;
enum ACSMode: NSUInteger;
enum ACSActionRole: NSUInteger;

@interface ACSBaseActionElement : ACSBaseElement

#ifdef __cplusplus
- (instancetype _Nonnull)initWithBaseActionElement:(const std::shared_ptr<BaseActionElement>)cppObj;
#endif

- (NSString * _Nullable)getTitle;
- (void)setTitle:(NSString * _Nonnull)value;
- (NSString * _Nullable)getIconUrl;
- (void)setIconUrl:(NSString * _Nonnull)value;
- (NSString * _Nullable)getStyle;
- (void)setStyle:(NSString * _Nonnull)value;
- (NSString * _Nullable)getTooltip;
- (void)setTooltip:(NSString * _Nonnull)value;
- (ACSActionType)getElementType;
- (ACSMode)getMode;
- (void)setMode:(enum ACSMode)mode;
- (bool)getIsEnabled;
- (void)setIsEnabled:(bool)isEnabled;
- (ACSActionRole)getRole;
- (void)setRole:(enum ACSActionRole)role;
- (void)getResourceInformation:(NSArray<ACSRemoteResourceInformation *>* _Nonnull)resourceUris;



@end
#endif
