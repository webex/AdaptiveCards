// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSRefresh_IMPORTED
#define ACSRefresh_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "Refresh.h"
using namespace AdaptiveCards;
#endif

#import "ACSBaseActionElement.h"

@class ACSBaseActionElement;



@interface ACSRefresh : NSObject
#ifdef __cplusplus
- (instancetype _Nonnull)initWithRefresh:(const std::shared_ptr<Refresh>)cppObj;
#endif

- (ACSBaseActionElement * _Nullable)getAction;
- (void)setAction:(ACSBaseActionElement * _Nonnull);
- (NSArray<NSString *> * _Nonnull)getUserIds;
- (void)setUserIds:(NSArray<NSString *>* _Nonnull);


@end
#endif