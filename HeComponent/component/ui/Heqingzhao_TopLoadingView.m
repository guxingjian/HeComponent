//
//  Heqingzhao_topLoadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_TopLoadingView.h"
#import "UIView+view_frame.h"

@implementation Heqingzhao_TopLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.style = Heqingzhao_LoadingViewStyle_LoadingView1;
    }
    return self;
}

- (void)setLoadingState:(Heqingzhao_LoadingViewState)loadingState{
    [super setLoadingState:loadingState];
    if(Heqingzhao_LoadingViewState_Normal == loadingState){
        self.stateLabel.text = @"下拉刷新数据";
    }else if(Heqingzhao_LoadingViewState_PrePareLoading == loadingState){
        self.stateLabel.text = @"松开刷新数据";
    }else if(Heqingzhao_LoadingViewState_Loading == loadingState){
        self.stateLabel.text = @"请求中...";
    }else if(Heqingzhao_LoadingViewState_EndLoading == loadingState){
        self.stateLabel.text = @"请求完毕";
    }
}

@end
