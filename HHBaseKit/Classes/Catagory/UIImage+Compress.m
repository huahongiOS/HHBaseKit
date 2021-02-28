//
//  UIImage+Compress.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

/// 压缩质量
/// @param maxLength  压缩后的图片质量 单位：byte
/// @param maxCompression  最大压缩比 例如：0.01
- (NSData *)compressQuality:(NSInteger)maxLength maxCompression:(CGFloat)maxCompression
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    while (data.length > maxLength && compression > maxCompression) {
        compression -= 0.01;
        data = UIImageJPEGRepresentation(self, compression);
    }
    return data;
}


/// 压缩质量二分法
/// @param maxLength  压缩后的图片质量 单位：byte
- (NSData *)compressMidQuality:(NSInteger)maxLength
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length <= maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i <= 10; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}



/// 压缩尺寸：根据质量压缩图片尺寸
/// @param maxLength 压缩后的图片质量 单位：byte
- (NSData *)compressSizeByLength:(NSUInteger)maxLength
{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),//sqrtf:开平方
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}


/// 根据指定尺寸进行压缩
/// @param size  压缩后的尺寸
- (NSData *)compressBySize:(CGSize)size
{
    CGFloat originWidth = self.size.width;
    CGFloat originHieght = self.size.height;
    if (!(originWidth <= size.width && originHieght <= size.height)) {
        
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
//        UIGraphicsBeginImageContext(CGSizeMake(originWidth, originHieght));
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage * resultImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return UIImageJPEGRepresentation(resultImg, 1.0);
    }
    return UIImageJPEGRepresentation(self, 1.0);
}

///// 先压缩质量,再根据质量压缩尺寸
///// @param maxLength  压缩后的图片质量 单位：byte
//- (NSData *)compressQualityAndSize:(NSUInteger)maxLength
//{
//
//    NSData *data = [self compressQuality:maxLength maxCompression:0.01];
//
//    if (data.length <= maxLength) return data;
//    UIImage *resultImage = [UIImage imageWithData:data];
//
//    NSUInteger lastDataLength = 0;
//    while (data.length > maxLength && data.length != lastDataLength) {
//        lastDataLength = data.length;
//        CGFloat ratio = (CGFloat)maxLength / data.length;
//
//        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
//                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
//        UIGraphicsBeginImageContext(size);
//        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//        resultImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        data = UIImageJPEGRepresentation(resultImage, 1);
//
//    }
//
//    NSLog(@"After compressing size loop, image size = %u KB", data.length / 1024);
//    return data;
//}
//
///// 先压缩质量,再指定尺寸压缩
///// @param maxLength  压缩后的图片质量 单位：byte
///// @param size  压缩后的图片尺寸
//- (NSData *)compressQuality:(NSUInteger)maxLength Size:(CGSize)size
//{
//
//   NSData *data = [self compressQuality:maxLength maxCompression:0.01];
//
//    UIImage *image = [UIImage imageWithData:data];
//    CGFloat originWidth = image.size.width;
//    CGFloat originHieght = image.size.height;
//
//    if (!(originWidth <= size.width && originHieght <= size.height)) {
//
//        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
//        UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
////        UIGraphicsBeginImageContext(CGSizeMake(originWidth, originHieght));
//        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//        UIImage * resultImg = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return UIImageJPEGRepresentation(resultImg, 1.0);
//    }
//
//
//    NSLog(@"After compressing size loop, image size = %u KB", data.length / 1024);
//    return data;
//}

@end
