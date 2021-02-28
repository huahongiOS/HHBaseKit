#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HHBaseKit.h"
#import "NSArray+NSDictionary_Log.h"
#import "NSArray+NSDirectory_Convert_m.h"
#import "NSDate+Category.h"
#import "NSObject+add.h"
#import "NSObject+swizzle.h"
#import "NSString+IdentityCard.h"
#import "NSTimer+HHTimer.h"
#import "UIAlertController+Color.h"
#import "UIButton+singleClick.h"
#import "UIButton+space.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import "UIImage+Compress.h"
#import "UIImageView+ZFCache.h"
#import "UILabel+autoReSize.h"
#import "UITextField+Limit.h"
#import "UITextView+Limit.h"
#import "UIView+AutoLayout.h"
#import "UIView+AZGradient.h"
#import "UIView+Extension.h"
#import "UIView+QKAddForFounderCorner.h"
#import "UIWindow+CurrentViewController.h"
#import "BaseModel.h"
#import "Singleton.h"
#import "Util.h"
#import "UtilsMacro.h"
#import "NSDictionary+CrashHandle.h"
#import "NSString+null.h"

FOUNDATION_EXPORT double HHBaseKitVersionNumber;
FOUNDATION_EXPORT const unsigned char HHBaseKitVersionString[];

