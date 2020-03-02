//
//  Heqz_topLoadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_TopLoadingView.h"
#import "UIView+view_frame.h"

@implementation Heqz_TopLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.style = Heqz_LoadingViewStyle_LoadingView1;
    }
    return self;
}

- (void)setLoadingState:(Heqz_LoadingViewState)loadingState{
    [super setLoadingState:loadingState];
    if(Heqz_LoadingViewState_Normal == loadingState){
        self.stateLabel.text = @"下拉刷新数据";
    }else if(Heqz_LoadingViewState_PrePareLoading == loadingState){
        self.stateLabel.text = @"松开刷新数据";
    }else if(Heqz_LoadingViewState_Loading == loadingState){
        self.stateLabel.text = @"请求中...";
    }else if(Heqz_LoadingViewState_EndLoading == loadingState){
        self.stateLabel.text = @"请求完毕";
    }
}

@end
