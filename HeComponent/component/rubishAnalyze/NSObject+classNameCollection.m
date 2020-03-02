//
//  Heqz_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "NSObject+classNameCollection.h"
#import "Heqz_RubishManager.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject(classNameCollection)

+ (void)exchangeInitialize{
    Method originalMethod = class_getClassMethod(self, @selector(initialize));
    Method targetMethod = class_getClassMethod(self, @selector(heqingzhao_initialize));
    method_exchangeImplementations(originalMethod, targetMethod);
} 

+ (void)heqingzhao_initialize{
    [self heqingzhao_initialize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Heqz_RubishManager sharedManager] collectUsedClassName:NSStringFromClass(self)];
    });
}

@end
