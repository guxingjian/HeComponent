//
//  Heqingzhao_NavigationBar+layoutSubViews.m
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
        CGFloat naviBarHeight = 64;
        CGFloat statusBarHeight = 20;
        //注意导航栏及状态栏高度适配
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), naviBarHeight);
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }
            else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                frame.origin.y = statusBarHeight;
                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
}

- (BOOL)requireLayoutBarFrame{
    return ![self.delegate isKindOfClass:[UINavigationController class]];
}

@end
