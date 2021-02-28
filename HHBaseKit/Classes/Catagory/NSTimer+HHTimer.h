//
//  NSTimer+HHTimer.h
//  HuaHong
//
//  Created by 华宏 on 2018/12/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (HHTimer)


/// 自定义的Timer构造函数
/// @param interval 时间间隔
/// @param repeats 是否重复
/// @param block 事件回调
+ (NSTimer *)hhscheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;


/// 暂停
- (void)pauseTimer;


/// 继续
- (void)resumeTimer;

- (void)resumeWithInterval:(NSTimeInterval)time;


@end

NS_ASSUME_NONNULL_END
