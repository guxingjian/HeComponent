//
//  Heqingzhao_bottomLoadingView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_BottomLoadingView.h"

@implementation Heqingzhao_BottomLoadingView

- (UILabel *)labelText{
    if(!_labelText){
        _labelText = [[UILabel alloc] initWithFrame:self.bounds];
        _labelText.textAlignment = NSTextAlignmentCenter;
        _labelText.font = [UIFont systemFontOfSize:15];
        _labelText.textColor = [UIColor blackColor];
        [self addSubview:_labelText];
    }
    return _labelText;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.labelText.text = @"上拉加载更多数据";
    }
    return self;
}

- (void)startLoading{
    self.labelText.text = @"加载中...";
}

- (void)endLoading{
    self.labelText.text = @"加载完毕";
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    self.labelText.text = @"上拉加载更多数据";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.labelText.frame = self.bounds;
}


@end
