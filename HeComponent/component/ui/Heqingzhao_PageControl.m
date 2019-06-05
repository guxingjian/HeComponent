//
//  Heqingzhao_PageControl.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_PageControl.h"
#import "UIView+view_frame.h"

@implementation Heqingzhao_PageControlConfig

+ (instancetype)defaultConfig{
    Heqingzhao_PageControlConfig* config = [[self alloc] init];
    config.dotWidth = 6;
    config.dotHeight = 6;
    config.dotRadius = config.dotHeight/2;
    config.dotDis = config.dotWidth - 2;
    config.dotSelectedColor = [UIColor redColor];
    config.dotNormalColor = [UIColor blueColor];
    return config;
}

@end

@interface Heqingzhao_PageControl()

@property(nonatomic, strong)NSMutableArray* arrayDots;
@property(nonatomic, strong)UIView* selectedDotView;

@end

@implementation Heqingzhao_PageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setConfig:(Heqingzhao_PageControlConfig *)config{
    _config = config;
    if(!_config.dotContentDelegate){
        _config.dotContentDelegate = self;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if(_currentPage == currentPage)
        return ;
    _currentPage = currentPage;
    if(currentPage < self.arrayDots.count){
        self.selectedDotView.backgroundColor = _config.dotNormalColor;
        UIView* dotView = [self.arrayDots objectAtIndex:self.currentPage];
        dotView.backgroundColor = _config.dotSelectedColor;
        self.selectedDotView = dotView;
    }
}

- (void)settingChanged{
    if(_config && (_currentPage >= 0 && _currentPage < _numberOfPages)){
        if([_config.dotContentDelegate respondsToSelector:@selector(updatePageControlAppearance:)]){
            [_config.dotContentDelegate updatePageControlAppearance:self];
        }
    }
}

- (void)updatePageControlAppearance:(Heqingzhao_PageControl *)pageControl{
    CGFloat fTotalW = _numberOfPages*_config.dotWidth + (_numberOfPages+1)*_config.dotDis;
    CGFloat fPosX = 0;
    if(UIControlContentHorizontalAlignmentCenter == self.contentHorizontalAlignment){
        fPosX = self.width/2 - fTotalW/2;
    }else if(UIControlContentHorizontalAlignmentRight == self.contentHorizontalAlignment){
        fPosX = self.width - fTotalW;
    }
    UIView* contentView = [self viewWithTag:1001];
    if(!contentView){
        contentView = [[UIView alloc] initWithFrame:CGRectZero];
        contentView.tag = 1001;
        [self addSubview:contentView];
    }
    contentView.frame = CGRectMake(fPosX, self.height/2 - (_config.dotHeight + 2)/2, fTotalW, _config.dotHeight + 2);
    if(self.arrayDots.count < _numberOfPages){
        for(NSInteger i = self.arrayDots.count; i < _numberOfPages; ++ i){
            UIView* dotView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2 - _config.dotHeight/2, _config.dotWidth, _config.dotHeight)];
            dotView.backgroundColor = _config.dotNormalColor;
            dotView.layer.cornerRadius = dotView.height/2;
            dotView.layer.masksToBounds = YES;
            [contentView addSubview:dotView];
            [self.arrayDots addObject:dotView];
        }
    }else if(self.arrayDots.count > _numberOfPages){
        for(NSInteger i = _numberOfPages; i < self.arrayDots.count; ++ i){
            UIView* dotView = [self.arrayDots objectAtIndex:i];
            [dotView removeFromSuperview];
        }
        self.arrayDots = [NSMutableArray arrayWithArray:[self.arrayDots subarrayWithRange:NSMakeRange(0, _numberOfPages)]];
    }
    for(NSInteger i = 0; i < self.arrayDots.count; ++ i){
        UIView* dotView = [self.arrayDots objectAtIndex:i];
        dotView.x = (_config.dotDis + _config.dotWidth)*i + _config.dotDis;
    }
    if(_currentPage < self.arrayDots.count){
        self.selectedDotView.backgroundColor = _config.dotNormalColor;
        UIView* dotView = [self.arrayDots objectAtIndex:_currentPage];
        dotView.backgroundColor = _config.dotSelectedColor;
        _selectedDotView = dotView;
    }
}

- (NSMutableArray *)arrayDots{
    if(!_arrayDots){
        _arrayDots = [NSMutableArray array];
    }
    return _arrayDots;
}

@end
