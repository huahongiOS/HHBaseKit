//
//  UITextView+Limit.m
//  HuaHong
//
//  Created by 华宏 on 2020/5/1.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "UITextView+Limit.h"

@implementation UITextView (Limit)

/// 字数限制
/// @param limitCount 最大输入字数
/// @param range <#range description#>
/// @param string <#string description#>
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

@end
