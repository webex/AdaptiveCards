// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSTableColumnDefinition_IMPORTED
#define ACSTableColumnDefinition_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "TableColumnDefinition.h"
using namespace AdaptiveCards;
#endif

#import "ACSHorizontalAlignment.h"
#import "ACSVerticalContentAlignment.h"


enum ACSHorizontalAlignment: NSUInteger;
enum ACSVerticalContentAlignment: NSUInteger;


@interface ACSTableColumnDefinition : NSObject
#ifdef __cplusplus
- (instancetype _Nonnull)initWithTableColumnDefinition:(const std::shared_ptr<TableColumnDefinition>)cppObj;
#endif

- (ACSHorizontalAlignment)getHorizontalCellContentAlignment;
- (void)setHorizontalCellContentAlignment:(enum ACSHorizontalAlignment)value;
- (ACSVerticalContentAlignment)getVerticalCellContentAlignment;
- (void)setVerticalCellContentAlignment:(enum ACSVerticalContentAlignment)value;
- (NSNumber * _Nullable)getWidth;
- (void)setWidth:(NSNumber * _Nullable)value;
- (NSNumber * _Nullable)getPixelWidth;
- (void)setPixelWidth:(NSNumber * _Nullable)value;


@end
#endif
