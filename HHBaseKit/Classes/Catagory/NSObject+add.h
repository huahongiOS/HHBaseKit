//
//  NSObject+add.h
//  HuaHong
//
//  Created by 华宏 on 2020/1/15.
//  Copyright © 2020 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (add)


- (NSString *)JSONRepresentation;


- (id)JSONValue;


-(void)perform:(void (^)(void))performBlock;

-(void)perform:(void (^)(void))performBlock andDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
