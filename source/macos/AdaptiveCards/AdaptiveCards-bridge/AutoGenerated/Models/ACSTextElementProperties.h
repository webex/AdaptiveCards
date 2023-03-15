// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2


#ifndef ACSTextElementProperties_IMPORTED
#define ACSTextElementProperties_IMPORTED
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "TextElementProperties.h"
using namespace AdaptiveCards;
#endif

#import "ACSDateTimePreparser.h"
#import "ACSFontType.h"
#import "ACSForegroundColor.h"
#import "ACSTextSize.h"
#import "ACSTextWeight.h"





@class ACSDateTimePreparser;

enum ACSFontType: NSUInteger;
enum ACSForegroundColor: NSUInteger;
enum ACSTextSize: NSUInteger;
enum ACSTextWeight: NSUInteger;


@interface ACSTextElementProperties : NSObject

#ifdef __cplusplus
- (instancetype _Nonnull)initWithTextElementProperties:(const std::shared_ptr<TextElementProperties>)cppObj;
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
- (void)setLanguage:(NSString * _Nonnull)value;
- (NSString * _Nullable)getLanguage;


@end
#endif
