//
//  Heqingzhao_AppContext.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/22.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_AppContext.h"

static Heqingzhao_AppContext* appContext = nil;

@implementation Heqingzhao_AppContext

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appContext = [super allocWithZone:zone];
    });
    return appContext;
}

+ (instancetype)sharedAppContext{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appContext = [[self alloc] init];
    });
    return appContext;
}

- (id)copyWithZone:(NSZone *)zone{
    return appContext;
}

- (instancetype)init{
    if(self = [super init]){
        [self setupIPhoneType];
    }
    return self;
}

- (void)setupIPhoneType{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if(size.width > size.height){
        size.width = size.height + size.width;
        size.height = size.width - size.height;
        size.width = size.width - size.height;
    }
    
    //  iPhone5,6,6p比例一致，iPhoneX iPhoneXs iPhoneXsMax, iPhoneR 比例一致
    if(320 == size.width){
        if(480 == size.height){
            _iPhoneType = Heqingzhao_IPhoneType_IPhone4;
        }else if(568 == size.height){
            _iPhoneType = Heqingzhao_IPhoneType_IPhone5;
        }
    }else if(375 == size.width){
        if(667 == size.height){
            _iPhoneType = Heqingzhao_IPhoneType_IPhone6;
        }else if(812 == size.height){
            _iPhoneType = Heqingzhao_IPhoneType_IPhoneX;
        }
    }else if(414 == size.width){
        if(736 == size.height){
            _iPhoneType = Heqingzhao_IPhoneType_IPhone6P;
        }else if(896 == size.height){
            if(2 == [UIScreen mainScreen].scale){
                _iPhoneType = Heqingzhao_IPhoneType_IPhoneXR;
            }else if(3 == [UIScreen mainScreen].scale){
                _iPhoneType = Heqingzhao_IPhoneType_IPhoneXSMax;
            }
        }
    }
}

- (CGFloat)topBarHeight{
    if(Heqingzhao_IPhoneType_IPhoneX == _iPhoneType ||
       Heqingzhao_IPhoneType_IPhoneXR == _iPhoneType ||
       Heqingzhao_IPhoneType_IPhoneXSMax == _iPhoneType){
        return 84;
    }
    return 64;
}

- (CGFloat)screenBottomEdge{
    UIEdgeInsets insets = [self safeAreaInsets];
    return insets.bottom;
}

- (UIEdgeInsets)safeAreaInsets{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(Heqingzhao_IPhoneType_IPhoneX == _iPhoneType ||
       Heqingzhao_IPhoneType_IPhoneXR == _iPhoneType ||
       Heqingzhao_IPhoneType_IPhoneXSMax == _iPhoneType){
        if(UIDeviceOrientationIsPortrait(orientation)){
            insets.top = 88;
            insets.bottom = 34;
        }else if(UIDeviceOrientationIsLandscape(orientation)){
            insets.top = 44;
            insets.left = 44;
            insets.bottom = 21;
            insets.right = 44;
        }
    }else{
        if(UIDeviceOrientationIsPortrait(orientation)){
            insets.top = 64;
        }else if(UIDeviceOrientationIsLandscape(orientation)){
            insets.top = 32;
        }
    }
    return insets;
}

- (CGRect)safeAreaRect{
    UIEdgeInsets insets = [self safeAreaInsets];
    CGRect rt = CGRectMake(insets.left, insets.top, Heqingzhao_ScreenWidth - insets.left - insets.right, Heqingzhao_ScreenHeight - insets.top - insets.bottom);
    return rt;
}

@end
