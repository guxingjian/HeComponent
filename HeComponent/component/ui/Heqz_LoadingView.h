//
//  Heqz_loadingView.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, Heqz_LoadingViewState){
    Heqz_LoadingViewState_Normal,
    Heqz_LoadingViewState_PrePareLoading,
    Heqz_LoadingViewState_Loading,
    Heqz_LoadingViewState_EndLoading
};

typedef NS_OPTIONS(NSInteger, Heqz_LoadingViewStyle){
    Heqz_LoadingViewStyle_Default,
    Heqz_LoadingViewStyle_LoadingView1 // 带一个描述状态的label
};

@interface Heqz_LoadingView : UIControl

// 不要直接设置，请使用startLoading 和 endLoading
// 子类可以重写set方法添加自己的逻辑
@property(nonatomic, assign)Heqz_LoadingViewState loadingState;
@property(nonatomic, assign)Heqz_LoadingViewStyle style;
@property(nonatomic, strong)UILabel* stateLabel;
@property(nonatomic, assign)CGFloat loadingScale;

- (instancetype)initWithFrame:(CGRect)frame style:(Heqz_LoadingViewStyle)style;

- (void)startLoading;
- (void)endLoading;

@end
