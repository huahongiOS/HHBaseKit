//
//  UtilsMacro.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
//#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#define NSLog(...)
//#endif

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight self.tabBarController.tabBar.bounds.size.height
//#define kNavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height)
//#define kNavBarHeight  (KIsiPhoneX ? 88 : 64)
#define kNavBarHeight ((self.navigationController.navigationBar.hidden || !self.navigationController) ? [UIApplication sharedApplication].statusBarFrame.size.height : ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height))

#define kStory [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]

#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphoneX
#define KIsiPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

#define Font(a) [UIFont systemFontOfSize:a]


/**
* UIImageResizingModeTile 平铺
* UIImageResizingModeStretch 拉伸
*/
#define ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]

#define ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#endif /* UtilsMacro_h */
