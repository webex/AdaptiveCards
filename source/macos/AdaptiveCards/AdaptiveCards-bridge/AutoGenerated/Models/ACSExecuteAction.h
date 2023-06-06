// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSExecuteAction_IMPORTED
#define ACSExecuteAction_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "ExecuteAction.h"
using namespace AdaptiveCards;
#endif

#import "ACSAssociatedInputs.h"

#import "ACSBaseActionElement.h"

enum ACSAssociatedInputs: NSUInteger;


@interface ACSExecuteAction : ACSBaseActionElement
#ifdef __cplusplus
- (instancetype _Nonnull)initWithExecuteAction:(const std::shared_ptr<ExecuteAction>)cppObj;
#endif

- (NSString * _Nullable)getDataJson;
- (void)setDataJson:(NSString * _Nonnull)value;
- (NSString * _Nullable)getVerb;
- (void)setVerb:(NSString * _Nonnull)verb;
- (ACSAssociatedInputs)getAssociatedInputs;
- (void)setAssociatedInputs:(enum ACSAssociatedInputs)value;


@end
#endif