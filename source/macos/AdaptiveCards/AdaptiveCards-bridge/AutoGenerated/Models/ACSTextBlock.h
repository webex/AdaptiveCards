// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSTextBlock_IMPORTED
#define ACSTextBlock_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "TextBlock.h"
using namespace AdaptiveCards;
#endif

#import "ACSDateTimePreparser.h"
#import "ACSFontType.h"
#import "ACSForegroundColor.h"
#import "ACSHorizontalAlignment.h"
#import "ACSTextSize.h"
#import "ACSTextStyle.h"
#import "ACSTextWeight.h"



#import "ACSBaseCardElement.h"


@class ACSDateTimePreparser;

enum ACSFontType: NSUInteger;
enum ACSForegroundColor: NSUInteger;
enum ACSHorizontalAlignment: NSUInteger;
enum ACSTextSize: NSUInteger;
enum ACSTextStyle: NSUInteger;
enum ACSTextWeight: NSUInteger;


@interface ACSTextBlock : ACSBaseCardElement

#ifdef __cplusplus
- (instancetype _Nonnull)initWithTextBlock:(const std::shared_ptr<TextBlock>)cppObj;
#endif

- (NSString * _Nullable)getText;
- (void)setText:(NSString * _Nonnull)value;
- (ACSDateTimePreparser * _Nullable)getTextForDateParsing;
- (ACSTextStyle _Nullable)getStyle;
- (void)setStyle:(enum ACSTextStyle _Nullable)value;
- (ACSTextSize _Nullable)getTextSize;
- (void)setTextSize:(enum ACSTextSize _Nullable)value;
- (ACSTextWeight _Nullable)getTextWeight;
- (void)setTextWeight:(enum ACSTextWeight _Nullable)value;
- (ACSFontType _Nullable)getFontType;
- (void)setFontType:(enum ACSFontType _Nullable)value;
- (ACSForegroundColor _Nullable)getTextColor;
- (void)setTextColor:(enum ACSForegroundColor _Nullable)value;
- (bool)getWrap;
- (void)setWrap:(bool)value;
- (bool _Nullable)getIsSubtle;
- (void)setIsSubtle:(bool _Nullable)value;
- (NSNumber * _Nullable)getMaxLines;
- (void)setMaxLines:(NSNumber * _Nonnull)value;
- (ACSHorizontalAlignment _Nullable)getHorizontalAlignment;
- (void)setHorizontalAlignment:(enum ACSHorizontalAlignment _Nullable)value;
- (void)setLanguage:(NSString * _Nonnull)value;
- (NSString * _Nullable)getLanguage;



@end
#endif
