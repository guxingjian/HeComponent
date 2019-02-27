//
//  Heqingzhao_AppContext.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/22.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define weak_Self __weak typeof(self) weakSelf = self

#define Heqingzhao_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Heqingzhao_ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_OPTIONS(NSInteger, Heqingzhao_IPhoneType){
    Heqingzhao_IPhoneType_Unknown,
    Heqingzhao_IPhoneType_IPhone4,
    Heqingzhao_IPhoneType_IPhone5,
    Heqingzhao_IPhoneType_IPhone6,
    Heqingzhao_IPhoneType_IPhone6P,
    Heqingzhao_IPhoneType_IPhoneX,
    Heqingzhao_IPhoneType_IPhoneXR,
    Heqingzhao_IPhoneType_IPhoneXSMax
};

@interface Heqingzhao_AppContext : NSObject<NSCopying>

@property(nonatomic, assign)Heqingzhao_IPhoneType iPhoneType;

+ (instancetype)sharedAppContext;

// 竖屏顶部导航栏高度
- (CGFloat)topNaviHeight;
// 竖屏顶部状态栏高度
- (CGFloat)topStatusBarHeight;

// 竖屏顶部导航栏+状态栏高度
- (CGFloat)topBarHeight;

@end
