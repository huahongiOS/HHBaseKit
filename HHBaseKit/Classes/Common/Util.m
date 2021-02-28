//
//  HHUil.m
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <Photos/Photos.h>
#import "NSObject+add.h"

@implementation Util

+ (NSString *)getAPPName{
    
    NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    
    return AppName;
    
}

+(NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

//生成XML
+(NSString*)makeXML:(NSDictionary*)param
{
    if( param.count == 0 ) return @"";
    
    NSArray* allKeys = param.allKeys;
    NSMutableString* mutableStr = NSMutableString.new;
    [mutableStr appendString:@"<xml>\n"];
    for ( NSString* key in allKeys ) {
        [mutableStr appendFormat:@"<%@>%@</%@>\n",key,param[key],key];
    }
    [mutableStr appendString:@"</xml>"];
    return mutableStr;
}


/** 拨打电话 */
//@"tel:%@",phoneNumber 在低版本系统无提示，直接拨打
+ (void)callPhone:(NSString *)phoneNumber
{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication]canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

///获取ip地址
+ (NSString *)getIPAddress
{
   NSError *error;
   NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
   
   NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
   //判断返回字符串是否为所需数据
   if ([ip hasPrefix:@"var returnCitySN = "]) {
       //对字符串进行处理，然后进行json解析
       //删除字符串多余字符串
       NSRange range = NSMakeRange(0, 19);
       [ip deleteCharactersInRange:range];
       NSString * nowIp =[ip substringToIndex:ip.length-1];
       //将字符串转换成二进制进行Json解析
       NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
       NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       if ([dict.allKeys containsObject:@"cip"]) {
           NSString *ipStr = [dict objectForKey:@"cip"];
           return ipStr;
       }
   }
    
    return @"";

}


/// 获取WiFi名称
+ (NSString *)getWiFiName
{
    NSDictionary *dict = [self SSIDInfo];
    NSString *SSID = dict[@"SSID"];
    return SSID;
}


/// 获取MAC地址
+ (NSString *)getMACAddress
{
    NSDictionary *dict = [self SSIDInfo];
    NSString *BSSID = dict[@"BSSID"];
    return BSSID;
}

+ (NSDictionary *)SSIDInfo

{
    //Access WiFi Infomation
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();

    NSDictionary *info = nil;

    for (NSString *ifnam in ifs) {

        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);

        if (info && [info count]) {

            break;

        }

    }

    return info;

}

//MARK: - 汉字转拼音
+ (NSString *)chineseConvertToPinYin:(NSString *)chinese
{
    NSString  *pinYinStr = [NSString string];
    
    if (chinese.length){
        NSMutableString * pinYin = [[NSMutableString alloc]initWithString:chinese];
        //1.先转换为带声调的拼音
        if(CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"带声调的拼音: %@", pinYin);
        }
        //2.再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"不带声调的拼音: %@", pinYin);
        }
        //3.去除掉首尾的空白字符和换行字符
        pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //4.去除掉其它位置的空白字符和换行字符
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        [pinYinStr capitalizedString];
        
    }
    return pinYinStr;
}


+ (void)updateVersion
{
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"LocalVersion:%@",localVersion);
    NSString *onlineVersion = @"8.8.1.0";
    if ([localVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedDescending) {
        //降序
        NSLog(@"%@  >  %@",localVersion,onlineVersion);
    }else if ([localVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedAscending){
        //升序
        NSLog(@"%@  <  %@",localVersion,onlineVersion);
    }else if ([localVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedSame){
        
        NSLog(@"%@  =  %@",localVersion,onlineVersion);
        
    }
   
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=1116017277"];
    [[[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
        
        NSLog(@"updateVersion:%@",dict);
        
        NSArray *results= [dict objectForKey:@"results"];
        if([results count])
        {
            NSDictionary *resDict= [results firstObject];
            NSString *trackViewUrl=[resDict objectForKey:@"trackViewUrl"];
            NSURL *jumpURL = [NSURL URLWithString:trackViewUrl?:@""];
            dispatch_after(0.2, dispatch_get_main_queue(), ^{
                
            if ([[UIApplication sharedApplication] canOpenURL:jumpURL]) {
                [[UIApplication sharedApplication]openURL:jumpURL];
            }
                
            });
        }
    }]resume];
    
    
}

#pragma mark - plist解析
+ (id)plist:(NSData *)data
{
    /**
     NSPropertyListImmutable 不可变
     NSPropertyListMutableContainers 容器可变
     NSPropertyListMutableContainersAndLeaves 容器和子节点都可变
     */
    id result = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
    
    NSLog(@"result:%@",result);
    
    return result;
}

//MARK: - 应用间跳转
+(BOOL)openAppWith:(NSString *)scheme andParam:(NSDictionary *)param
{
    NSString *str = @"";
    if (param) {
         
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSString *appUrl = [NSString stringWithFormat:@"%@://%@",scheme,str];
    NSString *dataStr = [appUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:dataStr];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
        
        return YES;
    } else {
        return NO;
    }
}

+(NSDictionary *)dealWith:(NSURL *)url
{
    NSString *str = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *param = [[str componentsSeparatedByString:@"//"] lastObject];
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"error == %@",error);
        return @{
                 @"error" : @"解析失败"
                 };
    }
    return dic;
}


+ (void)showTitles:(NSString *)otherTitles,.../*NS_REQUIRES_NIL_TERMINATION*/
{
    
    NSMutableArray *otherTitleArrM = [NSMutableArray array];
    
    va_list argList;
    if(otherTitles)
    {
        [otherTitleArrM addObject:otherTitles];
        va_start(argList, otherTitles);
        id temp;
        while((temp = va_arg(argList, id))){
            [otherTitleArrM addObject:temp];
        }
    }
    va_end(argList);
    

    for (NSString *otherTitle in otherTitleArrM) {
        
        NSLog(@"otherTitle:%@",otherTitle);
    }
    
}

+ (NSString *)nullToStr:(NSString *)str{
    if(str == NULL || str == nil || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"])
        return @"";
    return str;
}

+ (NSDictionary *)dataToDict:(id)data{
    NSDictionary *dict;
    if ([data isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary *)data;
    }else{
        dict = (NSDictionary *)[data JSONValue];
    }
    return dict;
}
/**
 *  @author zhengju, 16-06-29 10:06:05
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *  @param string 传入检测到中文字符串
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

+ (UINavigationController *)rootNav{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [vc isKindOfClass:[UINavigationController class]] ? (UINavigationController *)vc : nil;
}



/**
 * 截屏提醒
 */
-(void)addScreenShotAlert
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenAlert) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    
    //移除截屏提醒
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
   
}

/**
 * 录屏提醒
 * 投产版本 Version >= ?
 * @param requestData:title,msg,btn
 * @原生：songsx
 * @前端：?
 */
-(void)addScreenCapturedAlert
{
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureScreenAlert) name:UIScreenCapturedDidChangeNotification object:nil];
    }
    
    
    //移除录屏提醒
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    }
}

-(void)captureScreenAlert
{
    if (@available(iOS 11.0, *)) {
        // 开始录屏时有弹框提示，结束录屏时就不弹框了。
        if (![UIScreen mainScreen].isCaptured) {
            return;
        }
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"msg" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
           
           while (topRootViewController.presentedViewController)
           {
             topRootViewController = topRootViewController.presentedViewController;
           }
        
        [topRootViewController presentViewController:alertCtrl animated:YES completion:nil];
    }
}

@end
