//
//  Heqingzhao_SkinAppearance.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_ThemeStyleManager.h"
#import "Heqingzhao_ViewThemeDecorater.h"
#import "Heqingzhao_LabelThemeDecorater.h"
#import "Heqingzhao_ButtonThemeDecorater.h"
#import "UIView+ThemeConfig.h"

NSString* const controlKind_view = @"controlKind_view";
NSString* const controlKind_label = @"controlKind_label";
NSString* const controlKind_button = @"controlKind_button";
NSString* const Heqingzhao_ThemeStyleChanged = @"Heqingzhao_ThemeStyleChanged";

@interface Heqingzhao_ThemeStyleManager()

@end

@implementation Heqingzhao_ThemeStyleManager

+ (instancetype)defaultThemeStyleManager{
    static Heqingzhao_ThemeStyleManager* skinApp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skinApp = [[self alloc] init];
    });
    return skinApp;
}

- (instancetype)init{
    if(self = [super init]){
        [self registeDecoraterClass:[Heqingzhao_ViewThemeDecorater class] forViewKind:controlKind_view];
        [self registeDecoraterClass:[Heqingzhao_LabelThemeDecorater class] forViewKind:controlKind_label];
        [self registeDecoraterClass:[Heqingzhao_ButtonThemeDecorater class] forViewKind:controlKind_button];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:Heqingzhao_ThemeStyleChanged object:nil];
}

- (NSMutableDictionary *)dicViewDecorater{
    if(!_dicViewDecorater){
        _dicViewDecorater = [NSMutableDictionary dictionary];
    }
    return _dicViewDecorater;
}

- (void)registeDecoraterClass:(Class)cls forViewKind:(NSString *)viewKind{
    Heqingzhao_ViewThemeDecorater* viewDecorater = [[cls alloc] init];
    if(![viewDecorater isKindOfClass:[Heqingzhao_ViewThemeDecorater class]])
        return ;
    [self.dicViewDecorater setObject:viewDecorater forKey:viewKind];
}

- (void)decorateView:(UIView *)view ignoreOriginalSetting:(BOOL)ignore{
    if(!ignore && [self.currentTheme isEqualToString:view.currentConfigFile]){
        return ;
    }
    if(view.themeStyle.length == 0)
        return ;
    
    Heqingzhao_ViewThemeDecorater* viewDecorater = [self.dicViewDecorater objectForKey:view.controlKind];
    if(!viewDecorater)
        return ;
    [viewDecorater decorateView:view withConfig:[self.dicCurrentThemeConfig objectForKey:view.themeStyle]];
    view.currentConfigFile = self.currentTheme;
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
