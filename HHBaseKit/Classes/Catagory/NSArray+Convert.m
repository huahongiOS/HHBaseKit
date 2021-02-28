//
//  NSArray+Convert.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSArray+Convert.h"

@implementation NSArray (Convert)

- (NSString *)convertToJson
{
    NSString *jsonString;
    if ([NSJSONSerialization isValidJSONObject:self]) {
         NSError *error;
           NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
           if (error == nil) {
               jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
           }else
           {
              NSLog(@"NSArray转json失败");
           }
        
    }
   
    return jsonString;
}

@end

@implementation NSDictionary (Convert)

- (NSString *)convertToJson
{
    NSString *jsonString;
   if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
          if (error == nil) {
              jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          }else
          {
             NSLog(@"NSDictionary转json失败");
          }
       
   }
      
       return jsonString;
}
@end
