//
//  UIButton+action.h
//  测试定时器
//
//  Created by ldd on 2017/4/17.
//  Copyright © 2017年 刘懂懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (action)

- (void)addActionHandler:(void (^)(UIButton *button))block forControlEvents:(UIControlEvents)controlEvents;

 ///连续点击时间间隔
@property (nonatomic, assign) NSTimeInterval clickInterval;


@end
