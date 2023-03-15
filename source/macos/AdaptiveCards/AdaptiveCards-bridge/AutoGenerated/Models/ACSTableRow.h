// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSTableRow_IMPORTED
#define ACSTableRow_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "TableRow.h"
using namespace AdaptiveCards;
#endif

#import "ACSTableCell.h"
#import "ACSContainerStyle.h"
#import "ACSHorizontalAlignment.h"
#import "ACSVerticalContentAlignment.h"

#import "ACSBaseCardElement.h"
@class ACSTableCell;

enum ACSContainerStyle: NSUInteger;
enum ACSHorizontalAlignment: NSUInteger;
enum ACSVerticalContentAlignment: NSUInteger;


@interface ACSTableRow : ACSBaseCardElement
#ifdef __cplusplus
- (instancetype _Nonnull)initWithTableRow:(const std::shared_ptr<TableRow>)cppObj;
#endif

- (NSArray<ACSTableCell *> * _Nonnull)getCells;
- (void)setCells:(NSArray<ACSTableCell *>* _Nonnull)value;
- (ACSVerticalContentAlignment _Nullable)getVerticalCellContentAlignment;
- (void)setVerticalCellContentAlignment:(enum ACSVerticalContentAlignment _Nullable)value;
- (ACSHorizontalAlignment _Nullable)getHorizontalCellContentAlignment;
- (void)setHorizontalCellContentAlignment:(enum ACSHorizontalAlignment _Nullable)value;
- (ACSContainerStyle)getStyle;
- (void)setStyle:(enum ACSContainerStyle)value;


@end
#endif
