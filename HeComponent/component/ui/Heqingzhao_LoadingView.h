//
//  Heqingzhao_loadingView.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, Heqingzhao_LoadingViewState){
    Heqingzhao_LoadingViewState_Normal,
    Heqingzhao_LoadingViewState_PrePareLoading,
    Heqingzhao_LoadingViewState_Loading,
    Heqingzhao_LoadingViewState_EndLoading
};

typedef NS_OPTIONS(NSInteger, Heqingzhao_LoadingViewStyle){
    Heqingzhao_LoadingViewStyle_Default,
    Heqingzhao_LoadingViewStyle_LoadingView1 // 带一个描述状态的label
};

@interface Heqingzhao_LoadingView : UIControl

// 不要直接设置，请使用startLoading 和 endLoading
// 子类可以重写set方法添加自己的逻辑
@property(nonatomic, assign)Heqingzhao_LoadingViewState loadingState;
@property(nonatomic, assign)Heqingzhao_LoadingViewStyle style;
@property(nonatomic, strong)UILabel* stateLabel;
@property(nonatomic, assign)CGFloat loadingScale;

- (instancetype)initWithFrame:(CGRect)frame style:(Heqingzhao_LoadingViewStyle)style;

- (void)startLoading;
- (void)endLoading;

@end
