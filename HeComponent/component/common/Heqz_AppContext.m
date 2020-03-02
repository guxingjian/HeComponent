//
//  Heqz_AppContext.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/22.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_AppContext.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static Heqz_AppContext* appContext = nil;

@interface Heqz_AppContext()<CTTelephonyNetworkInfoDelegate>

@property(nonatomic, strong)CTTelephonyNetworkInfo* phoneNetInfo;

@end

@implementation Heqz_AppContext

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
        [self setupIPhoneCarrier];
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
            _iPhoneType = Heqz_IPhoneType_IPhone4;
        }else if(568 == size.height){
            _iPhoneType = Heqz_IPhoneType_IPhone5;
        }
    }else if(375 == size.width){
        if(667 == size.height){
            _iPhoneType = Heqz_IPhoneType_IPhone6;
        }else if(812 == size.height){
            _iPhoneType = Heqz_IPhoneType_IPhoneX;
        }
    }else if(414 == size.width){
        if(736 == size.height){
            _iPhoneType = Heqz_IPhoneType_IPhone6P;
        }else if(896 == size.height){
            if(2 == [UIScreen mainScreen].scale){
                _iPhoneType = Heqz_IPhoneType_IPhoneXR;
            }else if(3 == [UIScreen mainScreen].scale){
                _iPhoneType = Heqz_IPhoneType_IPhoneXSMax;
            }
        }
    }
}

- (void)dataServiceIdentifierDidChange:(NSString *)identifier{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupIPhoneCarrier];
    });
}

- (CTTelephonyNetworkInfo *)phoneNetInfo{
    if(!_phoneNetInfo){
        _phoneNetInfo = [[CTTelephonyNetworkInfo alloc] init];
        if(@available(iOS 13.0, *)){
            _phoneNetInfo.delegate = self;
        }else if(@available(iOS 12.0, *)){
            
            weak_Self;
            _phoneNetInfo.serviceSubscriberCellularProvidersDidUpdateNotifier = ^(NSString * _Nonnull param) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setupIPhoneCarrier];
                });
            };
        }else{
            weak_Self;
            _phoneNetInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier * _Nonnull carrier) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setupIPhoneCarrier];
                });
            };
        }
    }
    return _phoneNetInfo;
}

- (void)setupIPhoneCarrier{
    CTTelephonyNetworkInfo* info = self.phoneNetInfo;
    
    CTCarrier* carrier = [info subscriberCellularProvider];
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        _iPhoneCarrier = @"中国移动";
    }else if([code isEqualToString:@"01"] || [code isEqualToString:@"06"]){
        _iPhoneCarrier = @"中国联通";
    }else if([code isEqualToString:@"03"] || [code isEqualToString:@"05"]){
        _iPhoneCarrier = @"中国电信";
    }else if([code isEqualToString:@"20"]){
        _iPhoneCarrier = @"中国铁通";
    }else{
        _iPhoneCarrier = @"";
    }
}

- (CGFloat)topBarHeight{
    if(Heqz_IPhoneType_IPhoneX == _iPhoneType ||
       Heqz_IPhoneType_IPhoneXR == _iPhoneType ||
       Heqz_IPhoneType_IPhoneXSMax == _iPhoneType){
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
    if(Heqz_IPhoneType_IPhoneX == _iPhoneType ||
       Heqz_IPhoneType_IPhoneXR == _iPhoneType ||
       Heqz_IPhoneType_IPhoneXSMax == _iPhoneType){
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
    CGRect rt = CGRectMake(insets.left, insets.top, Heqz_ScreenWidth - insets.left - insets.right, Heqz_ScreenHeight - insets.top - insets.bottom);
    return rt;
}

@end
