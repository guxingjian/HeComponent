//
//  Heqz_NavigationBar+layoutSubViews.m
//  HeComponent
//
//  Created by qingzhao on 2019/5/24.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UINavigationBar+layoutSubViews.h"
#import <objc/runtime.h>

@implementation UINavigationBar(layoutSubViews)

+ (void)load {

    Method originalMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method targetMethod = class_getInstanceMethod(self, @selector(heqingzhao_layoutSubviews));
    method_exchangeImplementations(originalMethod, targetMethod);
}

- (void)heqingzhao_layoutSubviews{
    [self heqingzhao_layoutSubviews];
    
    if ([self requireLayoutBarFrame]) {
        for (UIView *view in self.subviews) {
            view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height, view.frame.size.width, view.frame.size.height);
        }
    }
}

- (BOOL)requireLayoutBarFrame{
    return ![self.delegate isKindOfClass:[UINavigationController class]];
}

@end
