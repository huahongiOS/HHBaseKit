//
//  UIDevice+Orientation.h
//  HuaHong
//
//  Created by 华宏 on 2020/12/22.
//  Copyright © 2020 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Orientation)

/**
 *  切换横竖屏
 *
 *  @param orientation UIInterfaceOrientation
 */
+ (void)switchOrientation:(UIInterfaceOrientation)orientation;

/**
 *  是否是横屏
 *
 *  @return 是 返回yes
 */
+ (BOOL)isOrientationLandscape;

@end

NS_ASSUME_NONNULL_END
