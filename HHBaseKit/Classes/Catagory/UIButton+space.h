//
//  UIButton+space.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ButtonImagePosition) {
    ButtonImagePositionTop,   //image在上
    ButtonImagePositionLeft,  //image在左
    ButtonImagePositionBottom,//image在下
    ButtonImagePositionRight  //image在右
};
@interface UIButton (space)

- (void)setImagePosition:(ButtonImagePosition)style Space:(CGFloat)space;

@end


