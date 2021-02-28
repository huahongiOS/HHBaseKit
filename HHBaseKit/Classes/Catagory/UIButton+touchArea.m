//
//  UIButton+touchArea.m
//  HuaHong
//
//  Created by 华宏 on 2021/2/27.
//  Copyright © 2021 huahong. All rights reserved.
//

#import "UIButton+touchArea.h"
#import <objc/runtime.h>

@implementation UIButton (touchArea)

- (UIEdgeInsets)touchAreaInsets
{
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{

    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

@end
