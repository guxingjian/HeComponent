//
//  Heqingzhao_loadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_LoadingView.h"

@interface Heqingzhao_LoadingView()

@property(nonatomic, readwrite)Heqingzhao_LoadingViewState state;

@end

@implementation Heqingzhao_LoadingView

- (void)prepareLoading{
    self.state = Heqingzhao_LoadingViewState_PrePareLoading;
}

- (void)startLoading{
    self.state = Heqingzhao_LoadingViewState_Loading;
}

- (void)endLoading{
    self.state = Heqingzhao_LoadingViewState_Normal;
}

@end
