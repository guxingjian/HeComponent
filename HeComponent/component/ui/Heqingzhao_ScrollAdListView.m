//
//  Heqingzhao_ScrollAdListView.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_ScrollAdListView.h"
#import "UIView+view_frame.h"

@interface Heqingzhao_ScrollAdListView()<UIScrollViewDelegate>

@property(nonatomic, strong)NSMutableArray* arrayItemViews;
@property(nonatomic, strong)UIScrollView* scrollContentView;
@property(nonatomic, strong)NSTimer* timer;

@end

@implementation Heqingzhao_ScrollAdListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFTimerInterval:(CGFloat)fTimerInterval{
    _fTimerInterval = fTimerInterval;
    if(0 == fTimerInterval){
        [self destoryTimer];
    }else{
        NSTimer* timer = [NSTimer timerWithTimeInterval:fTimerInterval target:self selector:@selector(timerTrigger) userInfo:nil repeats:YES];
        self.timer = timer;
    }
}

- (NSMutableArray *)arrayItemViews{
    if(!_arrayItemViews){
        _arrayItemViews = [NSMutableArray array];
    }
    return _arrayItemViews;
}

- (UIScrollView *)scrollContentView{
    if(!_scrollContentView){
        _scrollContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollContentView.pagingEnabled = YES;
        _scrollContentView.delegate = self;
        _scrollContentView.showsVerticalScrollIndicator = NO;
        _scrollContentView.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCurrentItem:)];
        [_scrollContentView addGestureRecognizer:tapGes];
        [self addSubview:_scrollContentView];
    }
    return _scrollContentView;
}

- (Heqingzhao_PageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[Heqingzhao_PageControl alloc] initWithFrame:CGRectZero];
        _pageControl.config = [Heqingzhao_PageControlConfig defaultConfig];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setArrayItems:(NSArray *)arrayItems{
    _arrayItems = arrayItems;
    self.pageControl.numberOfPages = arrayItems.count;
}

- (void)reloadAdList{
    if(self.arrayItems.count == 0)
        return ;
    
    UIScrollView* scrollView = self.scrollContentView;
    scrollView.frame = CGRectMake(0, 0, self.width, self.height - self.scrollBottomEdge);
    NSInteger targetCount = self.arrayItems.count + 2;
    if(self.arrayItemViews.count < targetCount){
        for(NSInteger i = self.arrayItemViews.count; i < targetCount; ++ i){
            UIView* itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
            [scrollView addSubview:itemView];
            [self.arrayItemViews addObject:itemView];
        }
    }else if(self.arrayItemViews.count > targetCount){
        for(NSInteger i = targetCount; i < self.arrayItemViews.count; ++ i){
            UIView* itemView = [self.arrayItemViews objectAtIndex:i];
            [itemView removeFromSuperview];
        }
        self.arrayItemViews = [NSMutableArray arrayWithArray:[self.arrayItemViews subarrayWithRange:NSMakeRange(0, self.arrayItems.count)]];
    }
    for(NSInteger i = 0; i < self.arrayItemViews.count; ++ i){
        UIView* itemView = [self.arrayItemViews objectAtIndex:i];
        NSInteger nIndex = 0;
        if(0 == i){
            nIndex = self.arrayItems.count - 1;
        }else if(i == self.arrayItemViews.count - 1){
            nIndex = 0;
        }else{
            nIndex = i - 1;
        }
        if([self.delegate respondsToSelector:@selector(adListView:setupItemView:itemIndex:itemModel:)]){
            [self.delegate adListView:self setupItemView:itemView itemIndex:nIndex itemModel:[self.arrayItems objectAtIndex:nIndex]];
        }
        itemView.frame = CGRectMake(i*scrollView.width, 0, scrollView.width, scrollView.height);
    }
    scrollView.contentSize = CGSizeMake(self.arrayItemViews.count*scrollView.width, scrollView.height);
    scrollView.contentOffset = CGPointMake(scrollView.width, 0);
    self.pageControl.frame = CGRectMake(0, 0, self.width, self.pageControl.config.dotHeight + 2);
    if(self.scrollBottomEdge > self.pageControl.height){
        self.pageControl.center = CGPointMake(self.width/2, self.height - self.scrollBottomEdge/2);
    }else{
        self.pageControl.y = self.height - self.pageControl.height;
    }
    [self.pageControl settingChanged];
    
    if(self.timer){
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger nPage = (scrollView.contentOffset.x + scrollView.width/2)/scrollView.width;
    if(0 == nPage){
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - 2*scrollView.width + scrollView.contentOffset.x, 0);
    }else if(nPage == self.arrayItemViews.count - 1){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - (scrollView.contentSize.width - 2*scrollView.width), 0);
    }else{
        self.pageControl.currentPage = nPage - 1;
    }
}

- (void)timerTrigger{
    UIScrollView* scrollView = self.scrollContentView;
    NSInteger nPage = (scrollView.contentOffset.x + scrollView.width + 0.5)/scrollView.width;
    [scrollView setContentOffset:CGPointMake(nPage*scrollView.width, 0) animated:YES];
}

- (void)destoryTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)selectCurrentItem:(UITapGestureRecognizer*)tapGes{
    if([self.delegate respondsToSelector:@selector(adListView:didSelectIndex:itemModel:)]){
        [self.delegate adListView:self didSelectIndex:self.pageControl.currentPage itemModel:[self.arrayItems objectAtIndex:self.pageControl.currentPage]];
    }
}

@end
