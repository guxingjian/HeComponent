//
//  Heqz_AppContext.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/22.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define weak_Self __weak typeof(self) weakSelf = self

#define Heqz_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Heqz_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Heqz_ScreenSafeAreaInsets [[Heqz_AppContext sharedAppContext] safeAreaInsets]
#define Heqz_ScreenSafeAreaRect [[Heqz_AppContext sharedAppContext] safeAreaRect]

typedef NS_OPTIONS(NSInteger, Heqz_IPhoneType){
    Heqz_IPhoneType_Unknown,
    Heqz_IPhoneType_IPhone4,
    Heqz_IPhoneType_IPhone5,
    Heqz_IPhoneType_IPhone6,
    Heqz_IPhoneType_IPhone6P,
    Heqz_IPhoneType_IPhoneX,
    Heqz_IPhoneType_IPhoneXR,
    Heqz_IPhoneType_IPhoneXSMax
};

@interface Heqz_AppContext : NSObject<NSCopying>

@property(nonatomic, assign)Heqz_IPhoneType iPhoneType;

// 当前运营商名称
@property(nonatomic, readonly)NSString* iPhoneCarrier;

+ (instancetype)sharedAppContext;

// 有导航栏的情况下，页面的safeArea
- (UIEdgeInsets)safeAreaInsets;
- (CGRect)safeAreaRect;

- (CGFloat)screenBottomEdge;

@end
