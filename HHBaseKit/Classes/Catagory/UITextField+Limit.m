//
//  UITextField+Limit.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UITextField+Limit.h"

@implementation UITextField (Limit)


#pragma mark - UITextFieldDelegate
#define myDotNumbers     @"0123456789.\n"
#define myNumbers        @"0123456789\n"

/**
 数字输入限制
 
 @param range range
 @param string string
 @param intLimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
- (BOOL)hh_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string IntLimit:(NSUInteger)intLimit DecimalLimit:(NSUInteger)decimalLimit
{
    NSCharacterSet *cs;
    NSUInteger dotLocation = [self.text rangeOfString:@"."].location;
    
    if (dotLocation == NSNotFound && range.location != 0)
    {
        if (range.location == intLimit && ![string isEqualToString:@"."])
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"."]invertedSet];
        }else
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
            
        }
    }else
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
    }
    NSString *filter = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    if (![filter isEqualToString:string])
    {
        return NO;
    }
    
    if (dotLocation != NSNotFound && range.location > dotLocation+decimalLimit) {
        return NO;
    }
    
    
    if ([self.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
        self.text = string;
        return NO;
    }
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    
    return YES;
}


/**
 正则表达式限制数字输入
 
 @param range range
 @param string string
 @param intLimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)regex_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string IntLimit:(NSUInteger)intLimit DecimalLimit:(NSUInteger)decimalLimit
{
    if ([self.text hasPrefix:@"0"] && ![string isEqualToString:@"."]) {
        self.text = string;
        return NO;
    }
    
    
    NSString *checkStr = [self.text stringByReplacingCharactersInRange:range withString:string];
    NSString *regex = [NSString stringWithFormat:@"^\\d{0,%lu}(\\.\\d{0,%lu})?$",(unsigned long)intLimit,(unsigned long)decimalLimit];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return [predicate evaluateWithObject:checkStr];
}

/**
 限制手机号输入
 
 @param range range
 @param string string
 @return 能否输入
 */
-(BOOL)checkPhoneNumber_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSInteger length = textField.text.length - range.length + string.length;
//    return (length <= 11);
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    NSString *checkStr = [self.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![checkStr hasPrefix:@"1"]) {
        self.text = nil;
      return NO;
    }
    
    if (self.text.length >= 11) {
        return NO;
    }
 
    return YES;
}



/// 字数限制
/// @param limitCount 最大输入字数
/// @param range range
/// @param string string
- (BOOL)limitCount:(NSUInteger)limitCount shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"range:%@",NSStringFromRange(range));
    NSLog(@"string:%@",string);

    UITextRange *markedTextRange = [self markedTextRange];
    NSLog(@"markedTextRange:%@",markedTextRange);

    
    //获取高亮部分
    UITextPosition *position = [self positionFromPosition:markedTextRange.start offset:0];
    NSLog(@"position:%@",position);

     //获取高亮部分内容
     //NSString * selectedtext = [textField textInRange:selectedRange];

     //如果有高亮且当前字数开始位置小于最大限制时允许输入
     if (markedTextRange && position)
     {
         NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:markedTextRange.start];
         NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:markedTextRange.end];
         NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
         return offsetRange.location < limitCount;
         
     }

     NSString *comcatstr = [self.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"comcatstr:%@",comcatstr);

     NSInteger caninputlen = limitCount - comcatstr.length;

     if (caninputlen >= 0)
     {
        return YES;
     }else
     {
         NSInteger len = string.length + caninputlen;
         //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
         NSRange rg = {0,MAX(len,0)};

         if (rg.length > 0)
         {
                 NSString *s = @"";
                 //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                 BOOL asc = [string canBeConvertedToEncoding:NSASCIIStringEncoding];
                 if (asc)
                 {
                     //因为是ascii码直接取就可以了不会错
                    s = [string substringWithRange:rg];
                 }else
                 {
                     __block NSInteger idx = 0;
                     __block NSString  *trimString = @"";//截取出的字串
                     //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                     [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                                                  options:NSStringEnumerationByComposedCharacterSequences
                                                               usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                            
                                                                       if (idx >= rg.length) {
                                                                               *stop = YES; //取出所需要就break，提高效率
                                                                               return ;
                                                                          }
                            
                                                                       trimString = [trimString stringByAppendingString:substring];
                            
                                                                       idx++;
                                                                   }];
    
                       s = trimString;
                    }
             
                 //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                 [self setText:[self.text stringByReplacingCharactersInRange:range withString:s]];
             }
         return NO;
        }
   
    return YES;
}


- (void)textDidChange:(UITextField *)textField
{
 
//    [self addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];

    
//    UITextRange *selectedRange = [textField markedTextRange];
//    NSString *newText = [textField textInRange:selectedRange];
//    NSLog(@"newText:%@",textField.text);
    
   
    //     if (range.length == 1 && string.length == 0) {
    //            return YES;
    //        }
    //
    //    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    checkStr = [checkStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSString * regex = [NSString stringWithFormat:@"^[A-Za-z0-9]{0,%lu}$",(unsigned long)4];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    ////    return [predicate evaluateWithObject:checkStr];
    
    CGFloat maxLength = 4;
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if(!position || !selectedRange)
    {
        if(toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];

            if(rangeIndex.length == 1)
            {
               textField.text = [toBeString substringToIndex:maxLength];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }

        }

    }
    
    
//    CGFloat maxInputLenght = 4;
//
//
//
//        NSString *InputMethodType = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
//
//    NSLog(@"InputMethodType:%@",InputMethodType);
//        // 如果当前输入法为汉语输入法
//        if ([InputMethodType isEqualToString:@"zh-Hans"]) {
//
//            // 获取标记部分
//            UITextRange *selectedRange = [self markedTextRange];
//
//            //获取标记部分, 此部分为用户未决定输入部分
//            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
//
//            // 当没有标记部分时截取字符串
//            if (position == nil) {
//                if (self.text.length > maxInputLenght) {
//                    self.text = [self.text substringToIndex:maxInputLenght];
//                }
//            }
//        }else {
//            if (self.text.length > maxInputLenght) {
//                self.text = [self.text substringToIndex:maxInputLenght];
//            }
//        }
    
    
}
@end
