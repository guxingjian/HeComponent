//
//  Heqingzhao_MultiChannelEditCell.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/20.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelEditCell.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_ImageLoader.h"

@interface Heqingzhao_MultiChannelEditCell()

@property(nonatomic, strong)UIButton* deleteBtn;

@end

@implementation Heqingzhao_MultiChannelEditCell

- (UILabel *)labelTitle{
    if(!_labelTitle){
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelTitle.font = [UIFont systemFontOfSize:16];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.layer.masksToBounds = YES;
        _labelTitle.layer.borderWidth = 1;
        _labelTitle.backgroundColor = [UIColor whiteColor];
        _labelTitle.layer.cornerRadius = 6;
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.minimumScaleFactor = 0.7;
        [self.contentView addSubview:_labelTitle];
    }
    return _labelTitle;
}

- (void)setConfig:(Heqingzhao_MultiChannelConfig *)config{
    _config = config;
    self.labelTitle.text = config.topBarConfig.normalTitle;
}

- (void)setStatus:(BOOL)status{
    _status = status;
    if(status){
        self.labelTitle.layer.borderColor = [UIColor redColor].CGColor;
        self.labelTitle.text = self.config.topBarConfig.normalTitle;
        _labelTitle.textColor = [UIColor redColor];
    }else{
        self.labelTitle.layer.borderColor = [UIColor grayColor].CGColor;
        self.labelTitle.text = [NSString stringWithFormat:@"+%@", self.config.topBarConfig.normalTitle];
        _labelTitle.textColor = [UIColor grayColor];
    }
}

- (UIButton *)deleteBtn{
    if(!_deleteBtn){
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 10, 0, 10, 10)];
        [_deleteBtn setImage:[Heqingzhao_ImageLoader loadImage:@"label_delete"] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor grayColor];
        _deleteBtn.layer.cornerRadius = _deleteBtn.height/2;
        _deleteBtn.layer.masksToBounds = YES;
        [_deleteBtn addTarget:self action:@selector(deleteCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

- (void)deleteCellAction:(UIButton*)btn{
    if([self.delegate respondsToSelector:@selector(willRemoveeditCell:)]){
        [self.delegate willRemoveeditCell:self];
    }
}

- (void)setEditting:(BOOL)editting{
    _editting = editting;
    if(editting){
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.labelTitle.frame = CGRectMake(self.deleteBtn.width/2, self.deleteBtn.height/2, self.width - self.deleteBtn.width, self.height - self.deleteBtn.height);
}

@end
