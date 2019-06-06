//
//  Heqingzhao_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "NSBundle+nibCollection.h"
#import "Heqingzhao_RubishManager.h"

#import <objc/runtime.h>

@implementation NSBundle(nibCollection)

+(void)load{
    Method originalMethod = class_getInstanceMethod(self, @selector(loadNibNamed:owner:options:));
    Method targetMethod = class_getInstanceMethod(self, @selector(heqingzhao_loadNibNamed:owner:options:));
    method_exchangeImplementations(originalMethod, targetMethod);
}

- (NSArray *)heqingzhao_loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary<UINibOptionsKey,id> *)options{
    [[Heqingzhao_RubishManager sharedManager] collectUsedXibName:name];
    return [self heqingzhao_loadNibNamed:name owner:owner options:options];
}

@end
