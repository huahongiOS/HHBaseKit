//
//  UIButton+space.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UIButton+space.h"

@implementation UIButton (space)

- (void)setImagePosition:(ButtonImagePosition)style Space:(CGFloat)space
{
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    /** 单行文字未发现差别，多行下面的才准确 */
//    CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
//    CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;
    
//    CGFloat titleWidth = self.titleLabel.size.width;
//    CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

    CGFloat  titleWidth = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName : self.titleLabel.font}
                                                         context:nil].size.width;
    
    CGFloat  titleHeight = [self.currentTitle boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : self.titleLabel.font}
                                                          context:nil].size.height;
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;

    switch (style) {
        case ButtonImagePositionTop:
        {
            imageInsets = UIEdgeInsetsMake(-(imageHeight+space)/2.0, titleWidth/2.0, (imageHeight+space)/2.0, -titleWidth/2.0);
            titleInsets = UIEdgeInsetsMake((titleHeight+space)/2.0, -imageWidth/2.0, -(titleHeight+space)/2.0, imageWidth/2.0);
        }
            break;
        
        case ButtonImagePositionBottom:
        {
            imageInsets = UIEdgeInsetsMake((imageHeight+space)/2.0, titleWidth/2.0, -(imageHeight+space)/2.0, -titleWidth/2.0);
            titleInsets = UIEdgeInsetsMake(-(titleHeight+space/2.0), -imageWidth/2.0, (titleHeight+space/2.0),imageWidth/2.0);
        }
            break;
        case ButtonImagePositionLeft:
        {
            imageInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            titleInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonImagePositionRight:
        {
            imageInsets = UIEdgeInsetsMake(0, (titleWidth+space/2.0), 0, -(titleWidth+space/2.0));
            titleInsets = UIEdgeInsetsMake(0, -(imageWidth+space/2.0), 0, (imageWidth+space/2.0));
        }
            break;
            
        default:
            break;
    }
    
    [self setTitleEdgeInsets:titleInsets];
    [self setImageEdgeInsets:imageInsets];
}
@end
