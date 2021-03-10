#import <Foundation/Foundation.h>

@class ACSMarkdownParserResult;
@class ACSTextBlock;
@class ACSHostConfig;
@class ACSRichTextElementProperties;

@interface BridgeTextUtils : NSObject

+ (ACSMarkdownParserResult * _Nonnull)processTextFromTextBlock:(ACSTextBlock * _Nonnull)textBlock hostConfig:(ACSHostConfig * _Nonnull)config;
+ (ACSMarkdownParserResult * _Nonnull)processTextFromRichTextBlock:(ACSTextRun * _Nullable)textBlock hostConfig:(ACSHostConfig * _Nonnull)config;
+ (ACSRichTextElementProperties * _Nonnull)convertTextBlockToRichTextElementProperties:(ACSTextBlock * _Nonnull)textBlock;
+ (ACSMarkdownParserResult * _Nonnull)processTextFromFacts:(ACSFact * _Nullable)facts hostConfig:(ACSHostConfig * _Nonnull)config;
+ (ACSRichTextElementProperties * _Nonnull)convertFactsToRichTextElementProperties:(ACSFact * _Nonnull)facts;
+ (ACSTextRun * _Nonnull)getTextRunFromInline:(ACSInline const *_Nonnull)inlineText;

@end
