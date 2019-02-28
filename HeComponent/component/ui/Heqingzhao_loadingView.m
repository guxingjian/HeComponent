//
//  Heqingzhao_loadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_loadingView.h"

@interface Heqingzhao_loadingView()

@property(nonatomic, readwrite)Heqingzhao_loadingViewState state;

@end

@implementation Heqingzhao_loadingView


- (void)startLoading{
    self.state = Heqingzhao_loadingViewState_Loading;
}

- (void)endLoading{
    self.state = Heqingzhao_loadingViewState_Normal;
}

@end
