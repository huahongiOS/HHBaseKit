//
//  UIView+QKAddForFounderCorner.m
//  自定义相机
//
//  Created by qk365 on 2018/4/23.
//  Copyright © 2018年 qk365. All rights reserved.
//

//  该类设置圆角的原理为在view的最上层绘制一张相应的遮罩图片，图片的背景只要保证和view的父视图背景色一样，就能达到圆角的效果，


#import "UIView+QKAddForFounderCorner.h"
#import <objc/runtime.h>

@implementation NSObject (_QKAdd)

+ (void)qk_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)qk_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)qk_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)qk_removeAssociateWithKey:(void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation UIImage (XWAddForRoundedCorner)

+ (UIImage *)qk_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)qk_maskRoundCornerRadiusImageWithColor:(UIColor *)color cornerRadii:(CGSize)cornerRadii size:(CGSize)size corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    return [UIImage qk_imageWithSize:size drawBlock:^(CGContextRef  _Nonnull context) {
        CGContextSetLineWidth(context, 0);
        [color set];
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectInset(rect, -0.3, -0.3)];
        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.3, 0.3) byRoundingCorners:corners cornerRadii:cornerRadii];
        [rectPath appendPath:roundPath];
        CGContextAddPath(context, rectPath.CGPath);
        CGContextEOFillPath(context);
        if (!borderColor || !borderWidth) return;
        [borderColor set];
        UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
        UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:cornerRadii];
        [borderOutterPath appendPath:borderInnerPath];
        CGContextAddPath(context, borderOutterPath.CGPath);
        CGContextEOFillPath(context);
    }];
}

@end

static void *const _QKMaskCornerRadiusLayerKey = "_QKMaskCornerRadiusLayerKey";
static NSMutableSet<UIImage *> *maskCornerRaidusImageSet;

@implementation CALayer (QKAddForRoundedCorner)

+ (void)load{
    [CALayer qk_swizzleInstanceMethod:@selector(layoutSublayers) with:@selector(_qk_layoutSublayers)];
}

- (UIImage *)contentImage{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.contents];
}

- (void)setContentImage:(UIImage *)contentImage{
    self.contents = (__bridge id)contentImage.CGImage;
}

- (void)qk_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color{
    [self qk_roundedCornerWithRadius:radius cornerColor:color corners:UIRectCornerAllCorners];
}

- (void)qk_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners{
    [self qk_roundedCornerWithCornerRadii:CGSizeMake(radius, radius) cornerColor:color corners:corners borderColor:nil borderWidth:0];
}

- (void)qk_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    if (!color) return;
    CALayer *cornerRadiusLayer = [self qk_getAssociatedValueForKey:_QKMaskCornerRadiusLayerKey];
    if (!cornerRadiusLayer) {
        cornerRadiusLayer = [CALayer new];
        cornerRadiusLayer.opaque = YES;
        [self qk_setAssociateValue:cornerRadiusLayer withKey:_QKMaskCornerRadiusLayerKey];
    }
    if (color) {
        [cornerRadiusLayer qk_setAssociateValue:color withKey:"_qk_cornerRadiusImageColor"];
    }else{
        [cornerRadiusLayer qk_removeAssociateWithKey:"_qk_cornerRadiusImageColor"];
    }
    [cornerRadiusLayer qk_setAssociateValue:[NSValue valueWithCGSize:cornerRadii] withKey:"_qk_cornerRadiusImageRadius"];
    [cornerRadiusLayer qk_setAssociateValue:@(corners) withKey:"_qk_cornerRadiusImageCorners"];
    if (borderColor) {
        [cornerRadiusLayer qk_setAssociateValue:borderColor withKey:"_qk_cornerRadiusImageBorderColor"];
    }else{
        [cornerRadiusLayer qk_removeAssociateWithKey:"_qk_cornerRadiusImageBorderColor"];
    }
    [cornerRadiusLayer qk_setAssociateValue:@(borderWidth) withKey:"_qk_cornerRadiusImageBorderWidth"];
    UIImage *image = [self _qk_getCornerRadiusImageFromSet];
    if (image) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = image;
        [CATransaction commit];
    }
    
}

- (UIImage *)_qk_getCornerRadiusImageFromSet{
    if (!self.bounds.size.width || !self.bounds.size.height) return nil;
    CALayer *cornerRadiusLayer = [self qk_getAssociatedValueForKey:_QKMaskCornerRadiusLayerKey];
    UIColor *color = [cornerRadiusLayer qk_getAssociatedValueForKey:"_qk_cornerRadiusImageColor"];
    if (!color) return nil;
    CGSize radius = [[cornerRadiusLayer qk_getAssociatedValueForKey:"_qk_cornerRadiusImageRadius"] CGSizeValue];
    NSUInteger corners = [[cornerRadiusLayer qk_getAssociatedValueForKey:"_qk_cornerRadiusImageCorners"] unsignedIntegerValue];
    CGFloat borderWidth = [[cornerRadiusLayer qk_getAssociatedValueForKey:"_qk_cornerRadiusImageBorderWidth"] floatValue];
    UIColor *borderColor = [cornerRadiusLayer qk_getAssociatedValueForKey:"_qk_cornerRadiusImageBorderColor"];
    if (!maskCornerRaidusImageSet) {
        maskCornerRaidusImageSet = [NSMutableSet new];
    }
    __block UIImage *image = nil;
    [maskCornerRaidusImageSet enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        CGSize imageSize = [[obj qk_getAssociatedValueForKey:"_qk_cornerRadiusImageSize"] CGSizeValue];
        UIColor *imageColor = [obj qk_getAssociatedValueForKey:"_qk_cornerRadiusImageColor"];
        CGSize imageRadius = [[obj qk_getAssociatedValueForKey:"_qk_cornerRadiusImageRadius"] CGSizeValue];
        NSUInteger imageCorners = [[obj qk_getAssociatedValueForKey:"_qk_cornerRadiusImageCorners"] unsignedIntegerValue];
        CGFloat imageBorderWidth = [[obj qk_getAssociatedValueForKey:"_qk_cornerRadiusImageBorderWidth"] floatValue];
        UIColor *imageBorderColor = [obj qk_getAssociatedValueForKey:"_qk_cornerRadiusImageBorderColor"];
        BOOL isBorderSame = (CGColorEqualToColor(borderColor.CGColor, imageBorderColor.CGColor) && borderWidth == imageBorderWidth) || (!borderColor && !imageBorderColor) || (!borderWidth && !imageBorderWidth);
        BOOL canReuse = CGSizeEqualToSize(self.bounds.size, imageSize) && CGColorEqualToColor(imageColor.CGColor, color.CGColor) && imageCorners == corners && CGSizeEqualToSize(radius, imageRadius) && isBorderSame;
        if (canReuse) {
            image = obj;
            *stop = YES;
        }
    }];
    if (!image) {
        image = [UIImage qk_maskRoundCornerRadiusImageWithColor:color cornerRadii:radius size:self.bounds.size corners:corners borderColor:borderColor borderWidth:borderWidth];
        [image qk_setAssociateValue:[NSValue valueWithCGSize:self.bounds.size] withKey:"_qk_cornerRadiusImageSize"];
        [image qk_setAssociateValue:color withKey:"_qk_cornerRadiusImageColor"];
        [image qk_setAssociateValue:[NSValue valueWithCGSize:radius] withKey:"_qk_cornerRadiusImageRadius"];
        [image qk_setAssociateValue:@(corners) withKey:"_qk_cornerRadiusImageCorners"];
        if (borderColor) {
            [image qk_setAssociateValue:color withKey:"_qk_cornerRadiusImageBorderColor"];
        }
        [image qk_setAssociateValue:@(borderWidth) withKey:"_qk_cornerRadiusImageBorderWidth"];
        [maskCornerRaidusImageSet addObject:image];
    }
    return image;
}
#pragma mark - exchage Methods

- (void)_qk_layoutSublayers{
    [self _qk_layoutSublayers];
    CALayer *cornerRadiusLayer = [self qk_getAssociatedValueForKey:_QKMaskCornerRadiusLayerKey];
    if (cornerRadiusLayer) {
        UIImage *aImage = [self _qk_getCornerRadiusImageFromSet];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = aImage;
        cornerRadiusLayer.frame = self.bounds;
        [CATransaction commit];
        [self addSublayer:cornerRadiusLayer];
    }
}

@end







@implementation UIView (QKAddForFounderCorner)

- (void)qk_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color{
    [self.layer qk_roundedCornerWithRadius:radius cornerColor:color];
}

- (void)qk_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners{
    [self.layer qk_roundedCornerWithRadius:radius cornerColor:color corners:corners];
}

- (void)qk_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    [self.layer qk_roundedCornerWithCornerRadii:cornerRadii cornerColor:color corners:corners borderColor:borderColor borderWidth:borderWidth];
}
@end
