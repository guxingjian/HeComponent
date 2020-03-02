//
//  Heqingzhao_SkinAppearance.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_ThemeSkinManager.h"
#import "Heqingzhao_ViewThemeDecorater.h"
#import "Heqingzhao_LabelThemeDecorater.h"
#import "Heqingzhao_ButtonThemeDecorater.h"
#import "UIView+ThemeConfig.h"

NSString* const Heqingzhao_ControlCategory_view = @"Heqingzhao_ControlCategory_view";
NSString* const Heqingzhao_ControlCategory_label = @"Heqingzhao_ControlCategory_label";
NSString* const Heqingzhao_ControlCategory_button = @"Heqingzhao_ControlCategory_button";
NSString* const Heqingzhao_ThemeSkinChanged = @"Heqingzhao_ThemeSkinChanged";

@interface Heqingzhao_ThemeSkinManager()

@end

@implementation Heqingzhao_ThemeSkinManager

+ (instancetype)defaultThemeSkinManager{
    static Heqingzhao_ThemeSkinManager* skinApp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skinApp = [[self alloc] init];
    });
    return skinApp;
}

- (instancetype)init{
    if(self = [super init]){
        [self registeDecoraterClass:[Heqingzhao_ViewThemeDecorater class] forViewCategory:Heqingzhao_ControlCategory_view];
        [self registeDecoraterClass:[Heqingzhao_LabelThemeDecorater class] forViewCategory:Heqingzhao_ControlCategory_label];
        [self registeDecoraterClass:[Heqingzhao_ButtonThemeDecorater class] forViewCategory:Heqingzhao_ControlCategory_button];
    }
    return self;
}

- (NSMutableDictionary *)dicThemeConfig{
    if(!_dicThemeConfig){
        _dicThemeConfig = [NSMutableDictionary dictionary];
    }
    return _dicThemeConfig;
}

- (void)loadThemeStyleFile:(NSString *)strFile{
    if([self.dicThemeConfig objectForKey:strFile]){
        return ;
    }
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:strFile ofType:nil];
    if(!filePath)
        return ;
    NSDictionary* dicThemeConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(!dicThemeConfig)
        return ;
    [self.dicThemeConfig setObject:dicThemeConfig forKey:strFile];
}

- (void)setCurrentTheme:(NSString *)currentTheme{
    if([currentTheme isEqualToString:self.currentTheme])
        return ;
    
    _currentTheme = currentTheme;
    [self loadThemeStyleFile:currentTheme];
    self.dicCurrentThemeConfig = [self.dicThemeConfig objectForKey:_currentTheme];
    [[NSNotificationCenter defaultCenter] postNotificationName:Heqingzhao_ThemeSkinChanged object:nil];
}

- (NSMutableDictionary *)dicViewDecorater{
    if(!_dicViewDecorater){
        _dicViewDecorater = [NSMutableDictionary dictionary];
    }
    return _dicViewDecorater;
}

- (void)registeDecoraterClass:(Class)cls forViewCategory:(NSString *)category{
    Heqingzhao_ViewThemeDecorater* viewDecorater = [[cls alloc] init];
    if(![viewDecorater isKindOfClass:[Heqingzhao_ViewThemeDecorater class]])
        return ;
    [self.dicViewDecorater setObject:viewDecorater forKey:category];
}

- (void)decorateView:(UIView *)view ignoreOriginalSetting:(BOOL)ignore{
    if(ignore || view.themeSkin.length == 0){
        return ;
    }
    
    Heqingzhao_ViewThemeDecorater* viewDecorater = [self.dicViewDecorater objectForKey:view.controlCategory];
    if(!viewDecorater)
        return ;
    [viewDecorater decorateView:view withConfig:[self.dicCurrentThemeConfig objectForKey:view.themeSkin]];
    if(view.decorateHandller){
        view.decorateHandller();
    }
}

- (void)decorateViewAndSubView:(UIView *)view ignoreOriginalSetting:(BOOL)ignore{
    NSMutableArray* arrayViews = [NSMutableArray array]; // 递归效率低，按层级遍历view的子view
    [arrayViews addObject:view];
    while (arrayViews.count > 0) {
        NSMutableArray* arrayTemp = [NSMutableArray array];
        for(UIView* v in arrayViews){
            [self decorateView:v ignoreOriginalSetting:ignore];
            if(v.subviews.count > 0){
                [arrayTemp addObjectsFromArray:v.subviews];
            }
        }
        arrayViews = arrayTemp;
    }
}

@end
