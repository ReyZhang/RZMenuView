//
//  NSString+UtilString.h
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (UtilString)

+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)isNotEmpty:(NSString *)string;
- (BOOL)isValidEmail;
- (BOOL)isValidNumber;
- (BOOL)isValidPhone;
- (BOOL)isValidURL;
+ (BOOL)isHtmlEmpty:(NSString *)htmlContent;
- (NSString *)URLEncoded;
- (NSString *)URLDecoded;
- (NSString *)stringTruncateToFit:(CGRect)rect withAttributes:(NSDictionary *)attributes;
- (NSString *)stringByDecodingURLFormat;
- (CGFloat) stringWidthWith:(CGFloat)fontSize;
- (CGFloat) stringHeightWith:(CGFloat)fontSize width:(CGFloat)width;
- (CGSize) stringSizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width;
- (NSString *)stringWithDateFormat:(NSString *)format toFormat:(NSString *)toFormat;
@end
