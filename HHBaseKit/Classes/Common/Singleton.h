//
//  Singleton.h
//  HuaHong
//
//  Created by 华宏 on 2020/9/24.
//  Copyright © 2020 huahong. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

// .h文件
#define SingletonH(name) + (instancetype)shared##name;

// .m文件
#define SingletonM(name) \
static id _instance; \
 \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
 \
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instance; \
}


#endif /* Singleton_h */
