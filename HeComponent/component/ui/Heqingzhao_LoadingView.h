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
    Heqingzhao_LoadingViewState_Loading
};

@interface Heqingzhao_LoadingView : UIView

@property(nonatomic, readonly)Heqingzhao_LoadingViewState state;

- (void)prepareLoading;
- (void)startLoading;
- (void)endLoading;

@end
