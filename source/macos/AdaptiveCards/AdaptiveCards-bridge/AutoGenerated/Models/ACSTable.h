// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSTable_IMPORTED
#define ACSTable_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "Table.h"
using namespace AdaptiveCards;
#endif

#import "ACSTableColumnDefinition.h"
#import "ACSTableRow.h"
#import "ACSContainerStyle.h"
#import "ACSHorizontalAlignment.h"
#import "ACSVerticalContentAlignment.h"

#import "ACSCollectionCoreElement.h"
@class ACSTableColumnDefinition;
@class ACSTableRow;

enum ACSContainerStyle: NSUInteger;
enum ACSHorizontalAlignment: NSUInteger;
enum ACSVerticalContentAlignment: NSUInteger;


@interface ACSTable : ACSCollectionCoreElement
#ifdef __cplusplus
- (instancetype _Nonnull)initWithTable:(const std::shared_ptr<Table>)cppObj;
#endif

- (bool)getShowGridLines;
- (void)setShowGridLines:(bool)value;
- (bool)getFirstRowAsHeaders;
- (void)setFirstRowAsHeaders:(bool)value;
- (ACSHorizontalAlignment)getHorizontalCellContentAlignment;
- (void)setHorizontalCellContentAlignment:(enum ACSHorizontalAlignment)value;
- (ACSVerticalContentAlignment)getVerticalCellContentAlignment;
- (void)setVerticalCellContentAlignment:(enum ACSVerticalContentAlignment)value;
- (ACSContainerStyle)getGridStyle;
- (void)setGridStyle:(enum ACSContainerStyle)value;
- (NSArray<ACSTableColumnDefinition *> * _Nonnull)getColumns;
- (void)setColumns:(NSArray<ACSTableColumnDefinition *>* _Nonnull)value;
- (NSArray<ACSTableRow *> * _Nonnull)getRows;
- (void)setRows:(NSArray<ACSTableRow *>* _Nonnull)value;


@end
#endif
