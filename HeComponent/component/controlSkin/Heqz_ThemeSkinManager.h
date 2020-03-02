//
//  Heqz_SkinAppearance.h
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const Heqz_ControlCategory_view;
extern NSString* const Heqz_ControlCategory_label;
extern NSString* const Heqz_ControlCategory_button;

@interface Heqz_ThemeSkinManager : NSObject

@property(nonatomic, strong)NSString* currentTheme; // 当前theme配置文件名
@property(nonatomic, strong)NSMutableDictionary* dicThemeConfig; // 配置文件名:配置文件内容
@property(nonatomic, strong)NSDictionary* dicCurrentThemeConfig; // 当前配置文件内容
@property(nonatomic, strong)NSMutableDictionary* dicViewDecorater; // 控件类型:控件theme装饰器

+ (instancetype)defaultThemeSkinManager; // 返回styleManager或其子类实例

// 注册控件类型对应的装饰器
- (void)registeDecoraterClass:(Class)cls forViewCategory:(NSString*)category;
// 设置view及其子view的theme
- (void)decorateView:(UIView*)view ignoreOriginalSetting:(BOOL)ignore;
- (void)decorateViewAndSubView:(UIView*)view ignoreOriginalSetting:(BOOL)ignore;

@end

extern NSString* const Heqz_ThemeSkinChanged;
