//
//  Heqingzhao_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UIImage+nameCollection.h"
#import "Heqingzhao_RubishManager.h"

#import <objc/runtime.h>

@implementation UIImage(nameCollection)

+(void)exchangeImageNamed{
    Method originalMethod = class_getClassMethod(self, @selector(imageNamed:));
    Method targetMethod = class_getClassMethod(self, @selector(heqingzhao_imageNamed:));
    method_exchangeImplementations(originalMethod, targetMethod);
    
    originalMethod = class_getInstanceMethod(self, @selector(initWithContentsOfFile:));
    targetMethod = class_getInstanceMethod(self, @selector(heqingzhao_initWithContentsOfFile:));
    method_exchangeImplementations(originalMethod, targetMethod);
}

+ (UIImage *)heqingzhao_imageNamed:(NSString *)name{
    [[Heqingzhao_RubishManager sharedManager] collectUsedImageName:name];
    return [self heqingzhao_imageNamed:name];
}

- (instancetype)heqingzhao_initWithContentsOfFile:(NSString *)path{
    NSString* imageName = [path pathComponents].lastObject;
    imageName = [imageName componentsSeparatedByString:@"@"].firstObject;
    [[Heqingzhao_RubishManager sharedManager] collectUsedImageName:imageName];
    return [self heqingzhao_initWithContentsOfFile:path];
}

@end


