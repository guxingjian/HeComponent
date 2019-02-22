//
//  Heqingzhao_MultiChannelContentView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/18.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelContentView.h"
#import "UIView+view_frame.h"

#define indexChangedDistance 0.99999f

@interface Heqingzhao_MultiChannelContentView()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView* contentScrollView;
@property(nonatomic, strong)NSMutableDictionary* dicContentView;
@property(nonatomic, assign)BOOL enableScroll;
@property(nonatomic, strong)NSMutableArray* banReuseView;
@property(nonatomic, strong)UIView* currentContentView;

@end

@implementation Heqingzhao_MultiChannelContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _selectedIndex = -1;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _selectedIndex = -1;
}

- (UIScrollView *)contentScrollView{
    if(!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (NSMutableDictionary *)dicContentView{
    if(!_dicContentView){
        _dicContentView = [NSMutableDictionary dictionary];
    }
    return _dicContentView;
}

- (NSMutableArray *)banReuseView{
    if(!_banReuseView){
        _banReuseView = [NSMutableArray array];
    }
    return _banReuseView;
}

- (UIView*)loadContentViewWithIndex:(NSInteger)nIndex{
    UIView* channelView = nil;
    
    Heqingzhao_MultiChannelConfig* config = [self.arrayTabItem objectAtIndex:nIndex];
    if(!self.enableReuseContentView){
        if([config.contentProvider respondsToSelector:@selector(contentViewWithIndex:config:)]){
            channelView = [config.contentProvider contentViewWithIndex:nIndex config:config];
        }
        if(!channelView){
            channelView = [[UIView alloc] initWithFrame:self.contentScrollView.bounds];
        }
    }else{
        NSMutableArray* arrayViews = [self.dicContentView objectForKey:config.contentResuseIdentifier];
        if(!arrayViews){
            arrayViews = [NSMutableArray array];
            [self.dicContentView setObject:arrayViews forKey:config.contentResuseIdentifier];
        }
        
        for(UIView* reuseView in arrayViews){
            if(![self.banReuseView containsObject:reuseView]){
                channelView = reuseView;
                break ;
            }
        }
        if(!channelView){
            if([config.contentProvider respondsToSelector:@selector(contentViewWithIndex:config:)]){
                channelView = [config.contentProvider contentViewWithIndex:nIndex config:config];
            }
            if(!channelView){
                channelView = [[UIView alloc] initWithFrame:self.contentScrollView.bounds];
            }
            
            [arrayViews addObject:channelView];
            [self.contentScrollView addSubview:channelView];
        }
    }
    
    CGRect frame = CGRectMake(nIndex*self.contentScrollView.width, 0, self.contentScrollView.width, self.contentScrollView.height);
    if(!CGRectEqualToRect(frame, channelView.frame)){
        channelView.frame = frame;
        [self.contentScrollView bringSubviewToFront:channelView];
    }
    
    return channelView;
}

- (UIView*)willSelectIndex:(NSInteger)nIndex{
    UIView* channelView = [self loadContentViewWithIndex:nIndex];
    if([self.delegate respondsToSelector:@selector(multiChannelContentView:willSelectIndex:withChannelView:andConfig:)]){
        [self.delegate multiChannelContentView:self willSelectIndex:nIndex withChannelView:channelView andConfig:[self.arrayTabItem objectAtIndex:nIndex]];
    }
    return channelView;
}

- (void)didSelectIndex:(NSInteger)nIndex{
    self.enableScroll = NO;
    [self.contentScrollView setContentOffset:CGPointMake(nIndex*self.contentScrollView.width, 0)];
    
    Heqingzhao_MultiChannelConfig* config = [self.arrayTabItem objectAtIndex:nIndex];
    if([self.delegate respondsToSelector:@selector(multiChannelContentView:didSelectIndex:withChannelView:andConfig:)]){
        [self.delegate multiChannelContentView:self didSelectIndex:nIndex withChannelView:[self.dicContentView objectForKey:config.itemIdentifier] andConfig:config];
    }
    self.enableScroll = YES;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if(_selectedIndex == selectedIndex)
        return ;
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    if(selectedIndex < 0 || selectedIndex >= self.arrayTabItem.count)
        return ;
    
    [self.banReuseView removeAllObjects];
    
    NSInteger preIndex = -1;
    NSInteger afterIndex = -1;
    if(selectedIndex - 1 != _selectedIndex){
        preIndex = selectedIndex - 1;
    }else{
        if(self.currentContentView){
            [self.banReuseView addObject:self.currentContentView];
        }
    }
    if(selectedIndex + 1 != _selectedIndex){
        afterIndex = selectedIndex + 1;
    }else{
        if(self.currentContentView){
            [self.banReuseView addObject:self.currentContentView];
        }
    }
    
    UIView* channelView = [self willSelectIndex:selectedIndex];
    [self.banReuseView addObject:channelView];

    _selectedIndex = selectedIndex;
    [self didSelectIndex:selectedIndex];
    self.currentContentView = channelView;
    
    if(preIndex >= 0 && preIndex < self.arrayTabItem.count){
        channelView = [self willSelectIndex:preIndex];
        [self.banReuseView addObject:channelView];
    }
    if(afterIndex >= 0 && afterIndex < self.arrayTabItem.count){
        channelView = [self willSelectIndex:afterIndex];
        [self.banReuseView addObject:channelView]; // 最后一个可加可不加
    }
}

- (void)setArrayTabItem:(NSArray *)arrayTabItem{
    _arrayTabItem = arrayTabItem;
    
    self.contentScrollView.contentSize = CGSizeMake(arrayTabItem.count*self.contentScrollView.width, 0);
    
    NSInteger selectedIndex = -1;
    for(NSInteger i = 0; i < arrayTabItem.count; ++ i){
        Heqingzhao_MultiChannelConfig* config = [arrayTabItem objectAtIndex:i];
        if(1 == config.status){
            selectedIndex = i;
            break ;
        }
    }
    
    if(-1 == selectedIndex){
        selectedIndex = 0;
    }
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!_enableScroll)
        return ;
    
    CGFloat fOffsetX = scrollView.contentOffset.x;
    CGFloat fIndex = fOffsetX/scrollView.width;
    
    if(fOffsetX >= 0 && fOffsetX <= scrollView.contentSize.width){
        if([self.delegate respondsToSelector:@selector(multiChannelContentView:scrollingWithIndex:)]){
            [self.delegate multiChannelContentView:self scrollingWithIndex:fIndex];
        }
    }
    
    if(fIndex > _selectedIndex){
        if((fIndex - _selectedIndex) >= indexChangedDistance){
            [self setSelectedIndex:_selectedIndex + 1 animated:NO];
        }
    }else if(fIndex < _selectedIndex){
        if((_selectedIndex - fIndex) >= indexChangedDistance){
            [self setSelectedIndex:_selectedIndex - 1 animated:NO];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if(CGRectEqualToRect(self.bounds, self.contentScrollView.frame))
        return ;
    
    self.contentScrollView.frame = self.bounds;
    for(NSInteger i = 0; i < self.arrayTabItem.count; ++ i){
        Heqingzhao_MultiChannelConfig* config = [self.arrayTabItem objectAtIndex:i];
        UIView* view = [self.dicContentView objectForKey:config.itemIdentifier];
        if(view){
            view.frame = CGRectMake(i*self.contentScrollView.width, view.top, self.contentScrollView.width, view.height);
        }
    }
}

@end
