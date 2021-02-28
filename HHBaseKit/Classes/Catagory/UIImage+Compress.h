//
//  UIImage+Compress.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

/// 压缩质量
/// @param maxLength  压缩后的图片质量 单位：byte
/// @param maxCompression  最大压缩比 例如：0.01
- (NSData *)compressQuality:(NSInteger)maxLength maxCompression:(CGFloat)maxCompression;


/// 压缩质量二分法
/// @param maxLength  压缩后的图片质量 单位：byte
- (NSData *)compressMidQuality:(NSInteger)maxLength;

/// 压缩尺寸：根据质量压缩图片尺寸
/// @param maxLength 压缩后的图片质量 单位：byte
- (NSData *)compressSizeByLength:(NSUInteger)maxLength;


/// 根据指定尺寸进行压缩
/// @param size  压缩后的尺寸
- (NSData *)compressBySize:(CGSize)size;

@end
