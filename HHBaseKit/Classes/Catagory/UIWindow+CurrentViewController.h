//
//  UIWindow+CurrentViewController.h
//  HuaHong
//
//  Created by 华宏 on 2020/9/14.
//  Copyright © 2020 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (CurrentViewController)

//MARK: - 获取当前控制器 方法一
+ (UIViewController*)currentViewController;

//MARK: - 获取当前VC 方法二
+ (UIViewController *)currentVC;

//MARK: - 获取当前VC 方法三
+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
