//
//  Heqingzhao_MultiChannelContentView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/18.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelContentView.h"
#import "UIView+view_frame.h"

@interface Heqingzhao_MultiChannelContentView()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView* contentScrollView;
@property(nonatomic, strong)NSMutableDictionary* dicContentView;
@property(nonatomic, assign)BOOL enableScroll;

@end

@implementation Heqingzhao_MultiChannelContentView

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

- (void)willSelectIndex:(NSInteger)nIndex triggerDelegate:(BOOL)bTrigger{
    Heqingzhao_MultiChannelConfig* config = [self.arrayTabItem objectAtIndex:nIndex];
    if(config.itemIdentifier.length == 0)
        return ;
    
    UIView* channelView = [self.dicContentView objectForKey:config.itemIdentifier];
    if(!channelView){
        if([config.contentProvider respondsToSelector:@selector(contentViewWithIndex:config:)]){
            channelView = [config.contentProvider contentViewWithIndex:nIndex config:config];
        }
        if(!channelView){
            channelView = [[UIView alloc] initWithFrame:self.contentScrollView.bounds];
        }
        
        [self.dicContentView setObject:channelView forKey:config.itemIdentifier];
        [self.contentScrollView addSubview:channelView];
    }
    CGRect frame = CGRectMake(nIndex*self.contentScrollView.width, 0, self.contentScrollView.width, self.contentScrollView.height);
    if(!CGRectEqualToRect(frame, channelView.frame)){
        channelView.frame = frame;
    }
    
    if(bTrigger){
        if([self.delegate respondsToSelector:@selector(multiChannelContentView:willSelectIndex:withChannelView:andConfig:)]){
            [self.delegate multiChannelContentView:self willSelectIndex:nIndex withChannelView:channelView andConfig:config];
        }
    }
}

- (void)didSelectIndex:(NSInteger)nIndex animated:(BOOL)animated  triggerDelegate:(BOOL)bTrigger{
    self.enableScroll = NO;
    [self.contentScrollView setContentOffset:CGPointMake(nIndex*self.contentScrollView.width, 0)];
    
    
    Heqingzhao_MultiChannelConfig* config = [self.arrayTabItem objectAtIndex:nIndex];
    if(bTrigger){
        if([self.delegate respondsToSelector:@selector(multiChannelContentView:didSelectIndex:withChannelView:andConfig:)]){
            [self.delegate multiChannelContentView:self didSelectIndex:nIndex withChannelView:[self.dicContentView objectForKey:config.itemIdentifier] andConfig:config];
        }
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
    
    NSInteger preIndex = -1;
    NSInteger afterIndex = -1;
    if(selectedIndex - 1 != _selectedIndex){
        preIndex = selectedIndex - 1;
    }
    if(selectedIndex + 1 != _selectedIndex){
        afterIndex = selectedIndex + 1;
    }

    [self willSelectIndex:selectedIndex triggerDelegate:YES];
    _selectedIndex = selectedIndex;
    [self didSelectIndex:selectedIndex animated:animated triggerDelegate:YES];
    
    if(preIndex >= 0){
        [self willSelectIndex:preIndex triggerDelegate:NO];
    }
    if(afterIndex < self.arrayTabItem.count){
        [self willSelectIndex:afterIndex triggerDelegate:NO];
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
    if(!self.enableScroll)
        return ;
    
    CGFloat fOffsetX = scrollView.contentOffset.x;
    if(fOffsetX >= scrollView.contentSize.width || fOffsetX <= 0)
        return ;
    
    CGFloat fIndex = fOffsetX/scrollView.width;
    if([self.delegate respondsToSelector:@selector(multiChannelContentView:scrollingWithIndex:)]){
        [self.delegate multiChannelContentView:self scrollingWithIndex:fIndex];
    }
    
    if(fIndex > _selectedIndex){
        NSInteger nIndex = (NSInteger)fIndex;
        if(nIndex != _selectedIndex){
            [self setSelectedIndex:nIndex animated:NO];
        }
    }else if(fIndex < _selectedIndex){
        NSInteger nIndex = (NSInteger)(_selectedIndex - fIndex);
        if(nIndex == 1){
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
