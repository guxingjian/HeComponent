//
//  Heqingzhao_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "NSObject+classNameCollection.h"
#import "Heqingzhao_RubishManager.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject(classNameCollection)

+ (void)exchangeAllocWithZone{
    Method originalMethod = class_getClassMethod(self, @selector(allocWithZone:));
    Method targetMethod = class_getClassMethod(self, @selector(heqingzhao_allocWithZone:));
    method_exchangeImplementations(originalMethod, targetMethod);
}

+ (instancetype)heqingzhao_allocWithZone:(struct _NSZone *)zone{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Heqingzhao_RubishManager sharedManager] collectUsedClassName:NSStringFromClass(self)];
    });
    return [self heqingzhao_allocWithZone:zone];
}

@end
