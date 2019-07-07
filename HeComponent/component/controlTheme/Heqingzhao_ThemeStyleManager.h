//
//  Heqingzhao_SkinAppearance.h
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const controlKind_view;
extern NSString* const controlKind_label;
extern NSString* const controlKind_button;

@interface Heqingzhao_ThemeStyleManager : NSObject

@property(nonatomic, strong)NSString* currentTheme;

+ (instancetype)defaultThemeStyleManager;

- (void)registeDecoraterClass:(Class)cls forViewKind:(NSString*)viewKind;
- (void)decorateView:(UIView*)view;

@end

extern NSString* const Heqingzhao_ThemeStyleChanged;
