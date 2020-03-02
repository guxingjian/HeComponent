//
//  Heqz_SkinAppearance.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_ThemeSkinManager.h"
#import "Heqz_ViewThemeDecorater.h"
#import "Heqz_LabelThemeDecorater.h"
#import "Heqz_ButtonThemeDecorater.h"
#import "UIView+ThemeConfig.h"

NSString* const Heqz_ControlCategory_view = @"Heqz_ControlCategory_view";
NSString* const Heqz_ControlCategory_label = @"Heqz_ControlCategory_label";
NSString* const Heqz_ControlCategory_button = @"Heqz_ControlCategory_button";
NSString* const Heqz_ThemeSkinChanged = @"Heqz_ThemeSkinChanged";

@interface Heqz_ThemeSkinManager()

@end

@implementation Heqz_ThemeSkinManager

+ (instancetype)defaultThemeSkinManager{
    static Heqz_ThemeSkinManager* skinApp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skinApp = [[self alloc] init];
    });
    return skinApp;
}

- (instancetype)init{
    if(self = [super init]){
        [self registeDecoraterClass:[Heqz_ViewThemeDecorater class] forViewCategory:Heqz_ControlCategory_view];
        [self registeDecoraterClass:[Heqz_LabelThemeDecorater class] forViewCategory:Heqz_ControlCategory_label];
        [self registeDecoraterClass:[Heqz_ButtonThemeDecorater class] forViewCategory:Heqz_ControlCategory_button];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:Heqz_ThemeSkinChanged object:nil];
}

- (NSMutableDictionary *)dicViewDecorater{
    if(!_dicViewDecorater){
        _dicViewDecorater = [NSMutableDictionary dictionary];
    }
    return _dicViewDecorater;
}

- (void)registeDecoraterClass:(Class)cls forViewCategory:(NSString *)category{
    Heqz_ViewThemeDecorater* viewDecorater = [[cls alloc] init];
    if(![viewDecorater isKindOfClass:[Heqz_ViewThemeDecorater class]])
        return ;
    [self.dicViewDecorater setObject:viewDecorater forKey:category];
}

- (void)decorateView:(UIView *)view ignoreOriginalSetting:(BOOL)ignore{
    if(ignore || view.themeSkin.length == 0){
        return ;
    }
    
    Heqz_ViewThemeDecorater* viewDecorater = [self.dicViewDecorater objectForKey:view.controlCategory];
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
