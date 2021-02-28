//
//  NSObject+add.m
//  HuaHong
//
//  Created by 华宏 on 2020/1/15.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "NSObject+add.h"

@implementation NSObject (add)



- (NSString *)JSONRepresentation
{
    NSString *str;
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *err;
        NSData *strData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&err];
        NSString *urlString = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        NSString *urlString1= [urlString stringByReplacingOccurrencesOfString:@"\n " withString:@""];
        str = [urlString1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return str;
}

- (id)JSONValue
{
    //处理报文
    NSError *err;
    //判断是否为json字符串
    if ([self isKindOfClass:[NSString class]])
    {
        NSString *jsonstr = (NSString*)self;
        //处理数组
        if ([jsonstr hasPrefix:@"["] && [jsonstr hasSuffix:@"]"]) {
            NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
            id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            return dict;
        }
        
        NSString *containString = @":";
        NSRange range = [jsonstr rangeOfString:containString];
        if (range.location == NSNotFound || !(jsonstr && jsonstr.length > 0))
        {
            return nil;
        }
    }
    else
    {
        NSString *jsonstr = [[NSString alloc]initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
        NSString *containString = @":";
        NSRange range = [jsonstr rangeOfString:containString];
        if (range.location == NSNotFound || !(jsonstr && jsonstr.length > 0))
        {
            return nil;
        }
    }
        if ([self isKindOfClass:[NSString class]])
        {
            NSString *jsonstr = (NSString*)self;
            NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
            id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            return dict;
        }
   
    id dict = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingAllowFragments error:&err];
    return dict;
}







-(void)perform:(void (^)(void))performBlock{
    
    performBlock();
    
}

-(void)perform:(void (^)(void))performBlock andDelay:(NSTimeInterval)delay{
    
    [self performSelector:@selector(perform:) withObject:(__bridge id)Block_copy((__bridge const void *)performBlock) afterDelay:delay];
    
    Block_release((__bridge const void *)performBlock);
}

@end
