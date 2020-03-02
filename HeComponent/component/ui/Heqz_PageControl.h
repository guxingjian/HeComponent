//
//  Heqz_PageControl.h
//  HeComponent
//
//  Created by qingzhao on 2019/6/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Heqz_PageControl;

@protocol Heqz_PageControlConfigDelegate <NSObject>

- (void)updatePageControlAppearance:(Heqz_PageControl*)pageControl;

@end

@interface Heqz_PageControlConfig : NSObject

@property(nonatomic, assign)CGFloat dotWidth;
@property(nonatomic, assign)CGFloat dotHeight;
@property(nonatomic, assign)CGFloat dotRadius;
@property(nonatomic, assign)CGFloat dotDis;
@property(nonatomic, strong)UIColor* dotSelectedColor;
@property(nonatomic, strong)UIColor* dotNormalColor;
@property(nonatomic, weak)id<Heqz_PageControlConfigDelegate> dotContentDelegate; // 设置pageControl样式的对象，默认为Heqz_PageControl

+ (instancetype)defaultConfig;

@end


@interface Heqz_PageControl : UIControl<Heqz_PageControlConfigDelegate>

@property(nonatomic, assign)NSInteger numberOfPages;
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, strong)Heqz_PageControlConfig* config;

// 设置完数据后调用，更新pageControl
- (void)settingChanged;

@end

NS_ASSUME_NONNULL_END
