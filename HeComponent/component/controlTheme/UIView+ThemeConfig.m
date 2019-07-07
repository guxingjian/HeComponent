//
//  UIView+SkinConfig.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UIView+ThemeConfig.h"
#import <objc/runtime.h>

@implementation UIView(ThemeConfig)

- (void)setThemeStyle:(NSString *)themeStyle{
    objc_setAssociatedObject(self, @"themeStyle", themeStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)themeStyle{
    return objc_getAssociatedObject(self, @"themeStyle");
}

- (void)setCurrentConfigFile:(NSString *)currentConfigFile{
    objc_setAssociatedObject(self, @"currentConfigFile", currentConfigFile, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)currentConfigFile{
    return objc_getAssociatedObject(self, @"currentConfigFile");
}

- (NSString *)controlKind{
    if([self isKindOfClass:[UIButton class]]){
        return @"controlKind_button";
    }else if([self isKindOfClass:[UILabel class]]){
        return @"controlKind_label";
    }else{
        return @"controlKind_view";
    }
}

@end
