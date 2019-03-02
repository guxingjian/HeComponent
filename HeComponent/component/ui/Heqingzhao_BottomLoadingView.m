//
//  Heqingzhao_bottomLoadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_BottomLoadingView.h"

@implementation Heqingzhao_BottomLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
       self.style = Heqingzhao_LoadingViewStyle_LoadingView1;
    }
    return self;
}

- (void)setLoadingState:(Heqingzhao_LoadingViewState)loadingState{
    [super setLoadingState:loadingState];
    if(Heqingzhao_LoadingViewState_Normal == loadingState){
        self.stateLabel.text = @"上拉加载更多";
    }else if(Heqingzhao_LoadingViewState_PrePareLoading == loadingState){
        self.stateLabel.text = @"松开加载更多";
    }else if(Heqingzhao_LoadingViewState_Loading == loadingState){
        self.stateLabel.text = @"加载中...";
    }else if(Heqingzhao_LoadingViewState_EndLoading == loadingState){
        self.stateLabel.text = @"加载完毕";
    }
}

@end
