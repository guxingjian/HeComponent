//
//  Heqz_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UINib+nibCollection.h"
#import "Heqz_RubishManager.h"

#import <objc/runtime.h>

@implementation UINib(nibCollection)

+(void)exchangeNibNamed{
    Method originalMethod = class_getClassMethod(self, @selector(nibWithNibName:bundle:));
    Method targetMethod = class_getClassMethod(self, @selector(heqingzhao_nibWithNibName:bundle:));
    method_exchangeImplementations(originalMethod, targetMethod);
}

+ (UINib *)heqingzhao_nibWithNibName:(NSString *)name bundle:(NSBundle *)bundleOrNil{
    [[Heqz_RubishManager sharedManager] collectUsedXibName:name];
    return [self heqingzhao_nibWithNibName:name bundle:bundleOrNil];
}

@end
