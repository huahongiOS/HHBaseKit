//
//  UITextView+Limit.h
//  HuaHong
//
//  Created by 华宏 on 2020/5/1.
//  Copyright © 2020 huahong. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Limit)

/// 字数限制
/// @param limitCount 最大输入字数
/// @param range range
/// @param string string
- (BOOL)limitCount:(NSUInteger)limitCount shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
