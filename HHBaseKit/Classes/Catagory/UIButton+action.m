//
//  UIButton+action.m
//  测试定时器
//
//  Created by ldd on 2017/4/17.
//  Copyright © 2017年 刘懂懂. All rights reserved.
//

#import "UIButton+action.h"
#import <objc/runtime.h>
#import "NSObject+swizzle.h"

static const void *UIButtonBlockKey = &UIButtonBlockKey;

@interface UIButton ()
@property (nonatomic, assign) NSTimeInterval lastClickTime;//上次点击时间
@end

@implementation UIButton (action)

//MARK: - block
- (void)addActionHandler:(void (^)(UIButton *button))block forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:controlEvents];
}

- (void)buttonClicked:(UIButton *)sender {
    void (^block)(UIButton *) = objc_getAssociatedObject(self, UIButtonBlockKey);
    !block ?: block(sender);
}


//MARK: - 连续点击
+ (void)load {
    
    [UIButton swizzleInstanceMethod:@selector(sendAction:to:forEvent:) swizzledSEL:@selector(swizzled_sendAction:to:forEvent:)];
}

- (NSTimeInterval)clickInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setClickInterval:(NSTimeInterval)clickInterval {
    objc_setAssociatedObject(self, @selector(clickInterval), @(clickInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )lastClickTime{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setLastClickTime:(NSTimeInterval)lastClickTime{
    objc_setAssociatedObject(self, @selector(lastClickTime), @(lastClickTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)swizzled_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    // 是否小于设定的时间间隔
    BOOL canClick = (NSDate.date.timeIntervalSince1970 - self.lastClickTime >= self.clickInterval);
    
    if (canClick) {
        
        [self swizzled_sendAction:action to:target forEvent:event];
        
        // 更新上一次点击时间戳
        self.lastClickTime = (self.clickInterval > 0) ? NSDate.date.timeIntervalSince1970 : self.lastClickTime;
    }
}

@end
