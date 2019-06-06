//
//  Heqingzhao_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "NSObject+classNameCollection.h"
#import "Heqingzhao_RubishManager.h"

@implementation NSObject(classNameCollection)

+ (void)initialize{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Heqingzhao_RubishManager sharedManager] collectUsedClassName:NSStringFromClass(self)];
    });
}

@end
