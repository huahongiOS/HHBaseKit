//
//  UIView+Extension.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/6.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "UIView+Extension.h"

//预编译函数
CG_INLINE CGPoint CGRectGetCenter1(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (Extension)

- (CGPoint) origin
{
    return self.frame.origin;
}

- (void)setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint)bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat)centerX
{
    return self.center.x;
}
    
- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}
    
- (CGFloat)centerY
{
    return self.center.y;
}
    
- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

    
// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}



- (UIViewController *)viewController {

    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);

    return nil;
}

/** 设置圆角 */
- (void)setCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, self.bounds.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
    
//判断一个view是否在主窗口上
-(BOOL)isShowingOnWindow
{

    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;


    //转换坐标系
    CGRect newFrame = [self.superview convertRect:self.frame toView:keywindow];

    CGRect windowBouns = keywindow.bounds;

    BOOL intersects =  CGRectIntersectsRect(newFrame, windowBouns);

    //判断一个控件是否真正显示在窗口范围内
    return !self.isHidden && self.alpha > 0.01 && intersects && self.window == keywindow;

}

-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset
{
    //给Cell设置阴影效果
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}

- (UIImage*)takeSnapshot:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

UINavigationController *selectedNavigationController()
{
    return  (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}


- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

//设置渐变色
- (void)setGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CAGradientLayer *gradientlayer = [[CAGradientLayer alloc]init];
    gradientlayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    gradientlayer.startPoint = startPoint;
    gradientlayer.endPoint = endPoint;
    gradientlayer.frame = self.bounds;
    [self.layer addSublayer:gradientlayer];
}

/**modalPresentationStyle
 圆角
 使用自动布局，需要在layoutsubviews 中使用
 @param radius 圆角尺寸
 @param corner 圆角位置
 */
- (void)acs_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corner;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

//MARK: - 截屏
- (UIView *)snapshotView:(UIView *)view
{
    
    UIView *snapshotView = nil;
    
    if ([view respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        snapshotView = [view snapshotViewAfterScreenUpdates:NO];
    } else {
        
       CGFloat radio = [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height;
       CGFloat h = CGRectGetWidth(view.frame) / radio;
       CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, h);
        
        UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        snapshotView = [[UIImageView alloc]initWithImage:image];
    }
        
    return snapshotView;
}

// 获取截图
- (UIImage *)imageFromView:(UIView *)theView
{
    UIImage* image = nil;
    UIScrollView *scrollView =(UIScrollView *)theView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect frame = scrollView.frame;
    
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = contentOffset;
    scrollView.frame = frame;
    
    UIGraphicsEndImageContext();
    
    return image;
}

//屏幕截图
+ (UIImage *)imageDataFromAll {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSData *imageData = [self compressImageNoAffectQuality:image];
//
//    NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return image;
}

@end
