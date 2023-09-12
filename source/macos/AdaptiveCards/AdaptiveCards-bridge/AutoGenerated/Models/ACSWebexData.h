// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSWebexData_IMPORTED
#define ACSWebexData_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "WebexData.h"
using namespace AdaptiveCards;
#endif

#import "ACSCardWidth.h"

enum ACSCardWidth: NSUInteger;


@interface ACSWebexData : NSObject
#ifdef __cplusplus
- (instancetype _Nonnull)initWithWebexData:(const std::shared_ptr<WebexData>)cppObj;
#endif

- (ACSCardWidth)getCardWidth;
- (void)setCardWidth:(enum ACSCardWidth)value;


@end
#endif
