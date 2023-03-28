// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSContentSource_IMPORTED
#define ACSContentSource_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "ContentSource.h"
using namespace AdaptiveCards;
#endif

//#import "ACSRemoteResourceInformation.h"

@class ACSRemoteResourceInformation;



@interface ACSContentSource : NSObject
#ifdef __cplusplus
- (instancetype _Nonnull)initWithContentSource:(const std::shared_ptr<ContentSource>)cppObj;
#endif

- (NSString * _Nullable)getMimeType;
- (void)setMimeType:(NSString * _Nonnull)value;
- (NSString * _Nullable)getUrl;
- (void)setUrl:(NSString * _Nonnull)value;
- (void)getResourceInformation:(NSArray<ACSRemoteResourceInformation *>* _Nonnull)resourceInfo;


@end
#endif
