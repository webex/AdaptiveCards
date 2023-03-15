// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSAuthentication_IMPORTED
#define ACSAuthentication_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "Authentication.h"
using namespace AdaptiveCards;
#endif

#import "ACSAuthCardButton.h"
#import "ACSTokenExchangeResource.h"

@class ACSAuthCardButton;
@class ACSTokenExchangeResource;



@interface ACSAuthentication : NSObject
#ifdef __cplusplus
- (instancetype _Nonnull)initWithAuthentication:(const std::shared_ptr<Authentication>)cppObj;
#endif

- (NSString * _Nullable)getText;
- (void)setText:(NSString * _Nonnull);
- (NSString * _Nullable)getConnectionName;
- (void)setConnectionName:(NSString * _Nonnull);
- (ACSTokenExchangeResource * _Nullable)getTokenExchangeResource;
- (void)setTokenExchangeResource:(ACSTokenExchangeResource * _Nonnull);
- (NSArray<ACSAuthCardButton *> * _Nonnull)getButtons;
- (void)setButtons:(NSArray<ACSAuthCardButton *>* _Nonnull);


@end
#endif