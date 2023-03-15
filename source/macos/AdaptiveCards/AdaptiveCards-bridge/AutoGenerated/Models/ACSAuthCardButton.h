// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSAuthCardButton_IMPORTED
#define ACSAuthCardButton_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "AuthCardButton.h"
using namespace AdaptiveCards;
#endif





@interface ACSAuthCardButton : NSObject
#ifdef __cplusplus
- (instancetype _Nonnull)initWithAuthCardButton:(const std::shared_ptr<AuthCardButton>)cppObj;
#endif

- (NSString * _Nullable)getType;

- (void)setType:(NSString * _Nonnull);
- (NSString * _Nullable)getTitle;

- (void)setTitle:(NSString * _Nonnull);
- (NSString * _Nullable)getImage;

- (void)setImage:(NSString * _Nonnull);
- (NSString * _Nullable)getValue;

- (void)setValue:(NSString * _Nonnull);


@end
#endif
