// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSTextRun_IMPORTED
#define ACSTextRun_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "TextRun.h"
using namespace AdaptiveCards;
#endif

#import "ACSBaseActionElement.h"
#import "ACSDateTimePreparser.h"
#import "ACSFontType.h"
#import "ACSForegroundColor.h"
#import "ACSTextSize.h"
#import "ACSTextWeight.h"



#import "ACSInline.h"


@class ACSBaseActionElement;
@class ACSDateTimePreparser;

enum ACSFontType: NSUInteger;
enum ACSForegroundColor: NSUInteger;
enum ACSTextSize: NSUInteger;
enum ACSTextWeight: NSUInteger;


@interface ACSTextRun : ACSInline

#ifdef __cplusplus
- (instancetype _Nonnull)initWithTextRun:(const std::shared_ptr<TextRun>)cppObj;
#endif

- (NSString * _Nullable)getText;
- (void)setText:(NSString * _Nonnull)value;
- (ACSDateTimePreparser * _Nullable)getTextForDateParsing;
- (ACSTextSize _Nullable)getTextSize;
- (void)setTextSize:(enum ACSTextSize _Nullable)value;
- (ACSTextWeight _Nullable)getTextWeight;
- (void)setTextWeight:(enum ACSTextWeight _Nullable)value;
- (ACSFontType _Nullable)getFontType;
- (void)setFontType:(enum ACSFontType _Nullable)value;
- (ACSForegroundColor _Nullable)getTextColor;
- (void)setTextColor:(enum ACSForegroundColor _Nullable)value;
- (bool _Nullable)getIsSubtle;
- (void)setIsSubtle:(bool _Nullable)value;
- (bool)getItalic;
- (void)setItalic:(bool)value;
- (bool)getStrikethrough;
- (void)setStrikethrough:(bool)value;
- (bool)getHighlight;
- (void)setHighlight:(bool)value;
- (void)setLanguage:(NSString * _Nonnull)value;
- (NSString * _Nullable)getLanguage;
- (bool)getUnderline;
- (void)setUnderline:(bool)value;
- (ACSBaseActionElement * _Nullable)getSelectAction;
- (void)setSelectAction:(ACSBaseActionElement * _Nonnull)action;



@end
#endif
