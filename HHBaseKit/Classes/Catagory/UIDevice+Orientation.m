//
//  UIDevice+Orientation.m
//  HuaHong
//
//  Created by 华宏 on 2020/12/22.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)

/**
 *  切换横竖屏
 *
 *  @param orientation UIInterfaceOrientation
 */
+ (void)switchOrientation:(UIInterfaceOrientation)orientation
{
    // setOrientation: 私有方法强制横屏
    if ([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
        
        
    }
    
}

/**
 *  是否是横屏
 *
 *  @return 是 返回ture
 */
+ (BOOL)isOrientationLandscape
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    return (UIInterfaceOrientationIsLandscape(statusBarOrientation));
}

@end
