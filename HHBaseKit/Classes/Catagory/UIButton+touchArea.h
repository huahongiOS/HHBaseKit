//
//  UIButton+touchArea.h
//  HuaHong
//
//  Created by 华宏 on 2021/2/27.
//  Copyright © 2021 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (touchArea)

/// 扩大点击范围。如上下左右都扩大20  UIEdgeInsetsMake(20, 20, 20, 20);
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

@end

NS_ASSUME_NONNULL_END
