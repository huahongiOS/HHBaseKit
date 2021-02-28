//
//  UIWindow+CurrentViewController.m
//  HuaHong
//
//  Created by 华宏 on 2020/9/14.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "UIWindow+CurrentViewController.h"

@implementation UIWindow (CurrentViewController)

//MARK: - 获取当前控制器 方法一
+ (UIViewController*)currentViewController{
    __block UIWindow *window;
    if (@available(iOS 13, *)) {
        [[UIApplication sharedApplication].connectedScenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull scene, BOOL * _Nonnull scenesStop) {
            if ([scene isKindOfClass: [UIWindowScene class]]) {
                UIWindowScene * windowScene = (UIWindowScene *)scene;
                [windowScene.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull windowTemp, NSUInteger idx, BOOL * _Nonnull windowStop) {
                    if (windowTemp.isKeyWindow) {
                        window = windowTemp;
                        *windowStop = YES;
                        *scenesStop = YES;
                    }
                }];
            }
        }];
    } else {
        window = [[UIApplication sharedApplication].delegate window];
    }
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}



//MARK: - other
//MARK: - 获取当前控制器 方法二
#define kAppDelegate       [UIApplication sharedApplication].delegate
+ (UIViewController *)currentVC{
    
    if ([kAppDelegate.window.rootViewController isKindOfClass:UINavigationController.class] || [kAppDelegate.window.rootViewController isKindOfClass:UITabBarController.class]) {
        return [self getVisibleViewControllerWithRootVC:kAppDelegate.window.rootViewController];
    }else{
        UIViewController *VC = kAppDelegate.window.rootViewController;
        if (VC.presentedViewController) {
            if ([VC.presentedViewController isKindOfClass:UINavigationController.class]||
                [VC.presentedViewController isKindOfClass:UITabBarController.class]) {
                return [self getVisibleViewControllerWithRootVC:VC.presentedViewController];
            }else{
                return VC.presentedViewController;
            }
        }
        else{
            return VC;
        }
    }
}

/**
 * 私有方法
 * rootVC必须是UINavigationController 或 UITabBarController 及其子类
 */
+ (UIViewController *)getVisibleViewControllerWithRootVC:(UIViewController *)rootVC{
    
    if ([rootVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)rootVC;
        // 如果有modal view controller并且弹起的是导航控制器，返回其topViewController
        if ([nav.visibleViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *presentdNav = (UINavigationController *)nav.visibleViewController;
            return presentdNav.visibleViewController;
        }
        else if ([nav.visibleViewController isKindOfClass:UITabBarController.class]){
            return [self getVisibleViewControllerWithRootVC:nav.visibleViewController];
        }
        else{
            return nav.visibleViewController;
        }
    }
    else if([rootVC isKindOfClass:UITabBarController.class]){
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        UINavigationController *nav = (UINavigationController *)tabVC.selectedViewController;
        return [self getVisibleViewControllerWithRootVC:nav];
    }else{
        return rootVC;
    }
}

//MARK: - 获取当前VC 方法三
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
