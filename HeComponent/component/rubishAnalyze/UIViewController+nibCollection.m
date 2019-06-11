//
//  Heqingzhao_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UIViewController+nibCollection.h"
#import "Heqingzhao_RubishManager.h"

#import <objc/runtime.h>

@implementation UIViewController(nibCollection)

+(void)exchangeInitWithNibName{
    Method originalMethod = class_getInstanceMethod(self, @selector(initWithNibName:bundle:));
    Method targetMethod = class_getInstanceMethod(self, @selector(heqingzhao_initWithNibName:bundle:));
    method_exchangeImplementations(originalMethod, targetMethod);
}

- (instancetype)heqingzhao_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    [[Heqingzhao_RubishManager sharedManager] collectUsedXibName:nibNameOrNil];
    return [self heqingzhao_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

@end
