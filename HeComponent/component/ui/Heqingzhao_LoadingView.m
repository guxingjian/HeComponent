//
//  Heqingzhao_loadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_LoadingView.h"


@implementation Heqingzhao_LoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(Heqingzhao_LoadingViewStyle)style{
    if(self = [super initWithFrame:frame]){
        self.style = style;
    }
    return self;
}

- (void)setloadingState:(Heqingzhao_LoadingViewState)loadingState{
    if(_loadingState == loadingState)
        return ;
    _loadingState = loadingState;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setStyle:(Heqingzhao_LoadingViewStyle)style{
    if(_style == style)
        return ;
    
    _style = style;
    if(Heqingzhao_LoadingViewStyle_Default == style){
        if(self.stateLabel){
            [self.stateLabel removeFromSuperview];
            self.stateLabel = nil;
        }
    }else if(Heqingzhao_LoadingViewStyle_LoadingView1){
        if(!_stateLabel){
            _stateLabel = [[UILabel alloc] initWithFrame:self.bounds];
            _stateLabel.textAlignment = NSTextAlignmentCenter;
            _stateLabel.font = [UIFont systemFontOfSize:15];
            _stateLabel.textColor = [UIColor blackColor];
            [self addSubview:_stateLabel];
        }
    }
}

- (void)startLoading{
    self.loadingState = Heqingzhao_LoadingViewState_Loading;
}

- (void)endLoading{
    self.loadingState = Heqingzhao_LoadingViewState_EndLoading;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.stateLabel.frame = self.bounds;
}

@end
