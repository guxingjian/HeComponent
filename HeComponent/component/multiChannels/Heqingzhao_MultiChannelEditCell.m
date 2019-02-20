//
//  Heqingzhao_MultiChannelEditCell.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/20.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelEditCell.h"

@implementation Heqingzhao_MultiChannelEditCell

- (UILabel *)labelTitle{
    if(!_labelTitle){
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelTitle.textColor = [UIColor blackColor];
        _labelTitle.font = [UIFont systemFontOfSize:16];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.layer.masksToBounds = YES;
        _labelTitle.layer.borderColor = [UIColor redColor].CGColor;
        _labelTitle.layer.borderWidth = 1;
        _labelTitle.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_labelTitle];
    }
    return _labelTitle;
}

- (void)setConfig:(Heqingzhao_MultiChannelConfig *)config{
    self.labelTitle.text = config.topBarConfig.normalTitle;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.labelTitle.frame = self.contentView.bounds;
    _labelTitle.layer.cornerRadius = _labelTitle.bounds.size.height/2;
}

- (void)beginMoving{
    
}

- (void)endMoving{
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(1 == self.indexPath.section){
        NSLog(@"frame: %@", NSStringFromCGRect(frame));
    }
}

@end
