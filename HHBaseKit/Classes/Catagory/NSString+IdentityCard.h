//
//  NSStri ng+IdentityCard.h
//  UUWorkplace
//
//  Created by 杨彬 on 15/1/25.
//  Copyright (c) 2015年 UU_Organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    isChinese,
    isEnglish,
    isOther,
} CharType;

@interface NSString (IdentityCard)
//验证身份证
+ (BOOL)validateIDCardNumber:(NSString *)value;
//验证身份证(已使用)
+(BOOL)checkIdentifier: (NSString *)Identifier;


//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email;
//验证手机号
+ (BOOL)isValidatePhone:(NSString *)phone;
//校验护照
+ (BOOL)isValidPassport:(NSString *)value;
//校验邮编
+ (BOOL) isValidZipcode:(NSString*)value;

//判断是否是大小写及数字
+ (BOOL)isValiAa1:(NSString *)value;

//判断是否是中文或字母组成
+ (CharType)isChineseOrAa:(NSString *)value;

+ (BOOL)isWechat:(NSString *)value;

+(BOOL)isValidateName:(NSString *)name;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+(CGFloat)CalculateStringWidthWithString:(NSString *)string Height:(CGFloat)height Font:(UIFont *)font;

+(CGFloat)CalculateStringHeightWithString:(NSString *)string Width:(CGFloat)width Font:(UIFont *)font;

/* !@brief **** 做微调---去掉左右空格  */
- (NSString *)doTrimming;

/* !@brief 186****5678 （号码中间隐藏）  */
- (NSString *)getHideNumber;

/* !@brief **** 做验证  */
- (BOOL)isEmpty;

//编码
-(NSString *)encode;

//解码
-(NSString *)decode;



//判断是否为Int形
+ (BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形
+ (BOOL)isPureFloat:(NSString*)string;



- (NSString *)urlEncoded;
- (NSString*)URLDecodedString;//返回urlGB18030编码字符串.

/**
 *    @brief    版本号比较.
 *
 *    @param     other     其他版本号.
 *
 *    @return    比较结果.
 */
- (NSComparisonResult)versionStringCompare:(NSString *)other;


/**
 *    @brief    Get参数内容转字典.
 *
 *    @param     encoding     字符串编码.
 *
 *    @return    参数字典集合.
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

/**
 *    @brief    Get参数转字典.
 *
 *    @param     encoding     字符串编码.
 *
 *    @return    参数字典集合.
 */
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

/**
 *    @brief    添加Get查询参数.
 *
 *    @param     query     待添加的参数字典.
 *
 *    @return    添加Get查询参数后的完整字符串.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 *    @brief    添加Get查询参数, 查询参数经过urlEncoded编码.
 *
 *    @param     query     待添加的参数字典.
 *
 *    @return    添加Get查询参数后的完整字符串.
 */
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query;

@end
