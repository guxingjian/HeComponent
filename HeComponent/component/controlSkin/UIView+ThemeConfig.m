//
//  UIView+SkinConfig.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UIView+ThemeConfig.h"
#import "Heqingzhao_ThemeSkinManager.h"
#import <objc/runtime.h>

@implementation UIView(ThemeConfig)

- (void)setThemeSkin:(NSString *)themeSkin{
    objc_setAssociatedObject(self, @"themeSkin", themeSkin, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[Heqingzhao_ThemeSkinManager defaultThemeSkinManager] decorateView:self ignoreOriginalSetting:NO];
}

- (NSString *)themeSkin{
    return objc_getAssociatedObject(self, @"themeSkin");
}

- (void)setDecorateHandller:(ThemeDecorateHandller)decorateHandller{
    objc_setAssociatedObject(self, @"decorateHandller", decorateHandller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ThemeDecorateHandller)decorateHandller{
    return objc_getAssociatedObject(self, @"decorateHandller");
}

- (NSString *)controlCategory{
    if([self isKindOfClass:[UIButton class]]){
        return Heqingzhao_ControlCategory_button;
    }else if([self isKindOfClass:[UILabel class]]){
        return Heqingzhao_ControlCategory_label;
    }else{
        return Heqingzhao_ControlCategory_view;
    }
}

@end
