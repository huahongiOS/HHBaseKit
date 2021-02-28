//
//  Util.h
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (NSString *)getAPPName;

+(NSString*)getAppVersion;

//生成XML
+(NSString*)makeXML:(NSDictionary*)param;

/** 拨打电话 */
+ (void)callPhone:(NSString *)phoneNumber;

//MARK: - 汉字转拼音
+ (NSString *)chineseConvertToPinYin:(NSString *)chinese;

//MARK: - 版本升级
+ (void)updateVersion;

#pragma mark - plist解析
+ (id)plist:(NSData *)data;

//多参数
//NS_REQUIRES_NIL_TERMINATION的作用是？
+ (void)showTitles:(NSString *)otherTitles,.../*NS_REQUIRES_NIL_TERMINATION*/;

/**
 * 字符串格式化，如果包含null，则为""
 */
+ (NSString *)nullToStr:(NSString *)str;
/**
 *对象转换成字典
 */
+ (NSDictionary *)dataToDict:(id)data;
/**
 *  @author zhengju, 16-06-29 10:06:05
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *  @param string 传入检测到中文字符串
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
+ (BOOL)checkIsChinese:(NSString *)string;

/**
 *获取根控制器
*/
+ (UINavigationController *)rootNav;

@end
