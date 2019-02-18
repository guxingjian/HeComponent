//
//  Heqingzhao_MultiChannelTopBar.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelTopBar.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_TabbarAdjustPosition.h"

@interface Heqingzhao_MultiChannelTopBar()

@property(nonatomic, strong)UIScrollView* tabItemScrollView;
@property(nonatomic, strong)NSMutableArray* arrayTabButtons;

@end

@implementation Heqingzhao_MultiChannelTopBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.rightItemWidth = 50;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.rightItemWidth = 50;
}

- (NSMutableArray *)arrayTabButtons{
    if(!_arrayTabButtons){
        _arrayTabButtons = [NSMutableArray array];
    }
    return _arrayTabButtons;
}

- (CGFloat)tabItemMaxHeight{
    if(_arrayTabItem.count > 0){
        Heqingzhao_MultiChannelConfig* tabItem = _arrayTabItem.firstObject;
        return tabItem.topBarConfig.maxHeight;
    }
    return 0;
}

- (void)buildTabItems
{
    NSArray* arrayTabItem = self.arrayTabItem;
    if(arrayTabItem.count == 0)
        return ;
    
    CGFloat fScrollHeight = self.itemBottomDistance*2;
    fScrollHeight += [self tabItemMaxHeight];
    
    if(!_tabItemScrollView){
        _tabItemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.height - fScrollHeight, self.width - self.rightItemWidth, fScrollHeight)];
        _tabItemScrollView.showsVerticalScrollIndicator = NO;
        _tabItemScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tabItemScrollView];
    }
    
    CGFloat fPosX = self.edgeSpace;
    UIButton* selectedBtn = nil;
    for(NSInteger i = 0; i < arrayTabItem.count; ++ i){
        UIButton* btnTab = nil;
        if(i < self.arrayTabButtons.count){
            btnTab = [self.arrayTabButtons objectAtIndex:i];
        }
        else{
            btnTab = [[UIButton alloc] initWithFrame:CGRectZero];
            [self.arrayTabButtons addObject:btnTab];
        }
        
        btnTab.tag = i;
        Heqingzhao_MultiChannelConfig* item = [arrayTabItem objectAtIndex:i];
        btnTab.frame = CGRectMake(fPosX, 0, item.topBarConfig.maxWidth, fScrollHeight);
        [btnTab setTitle:item.topBarConfig.normalTitle forState:UIControlStateNormal];
        [btnTab setTitleColor:item.topBarConfig.normalTextColor forState:UIControlStateNormal];
        [btnTab setTitle:item.topBarConfig.selectedTitle forState:UIControlStateSelected];
        [btnTab setTitleColor:item.topBarConfig.selectedTextColor forState:UIControlStateSelected];
        [btnTab addTarget:self action:@selector(tabItemAction:) forControlEvents:UIControlEventTouchUpInside];
        if(0 == item.status){
            btnTab.titleLabel.font = item.topBarConfig.normalFont;
        }else{
            btnTab.titleLabel.font = item.topBarConfig.selectedFont;
        }
        
        if(!btnTab.superview){
            [_tabItemScrollView addSubview:btnTab];
        }
        fPosX += item.topBarConfig.maxWidth;
        if(i != arrayTabItem.count - 1){
            fPosX += self.tabItemSpace;
        }else{
            fPosX += self.edgeSpace;
        }
        
        if(1 == item.status){
            selectedBtn = btnTab;
        }
    }
    _tabItemScrollView.contentSize = CGSizeMake(fPosX, 0);
    
    if(self.arrayTabButtons.count > arrayTabItem.count){
        for(NSInteger i = arrayTabItem.count; i < self.arrayTabButtons.count; ++ i){
            UIView* view = [self.arrayTabButtons objectAtIndex:i];
            [view removeFromSuperview];
        }
        self.arrayTabButtons = [NSMutableArray arrayWithArray:[self.arrayTabButtons subarrayWithRange:NSMakeRange(0, arrayTabItem.count)]];
    }
    
    if(Heqingzhao_MultiChannelTopBarLayout_Divide == self.tabItemLayout && self.arrayTabButtons.count > 0){
        if(fPosX > _tabItemScrollView.width)
            return ;
        
        CGFloat fSplit = _tabItemScrollView.width/self.arrayTabButtons.count;
        for(NSInteger i = 0; i < self.arrayTabButtons.count; ++ i){
            UIView* btn = [self.arrayTabButtons objectAtIndex:i];
            btn.frame = CGRectMake(i*fSplit + fSplit/2 - btn.width, btn.y, btn.width, btn.height);
        }
        _tabItemScrollView.contentSize = CGSizeMake(_tabItemScrollView.width, 0);
    }
    
    if(!selectedBtn){
        selectedBtn = self.arrayTabButtons.firstObject;
    }
    [self setSelectedIndex:selectedBtn.tag animated:NO];
}

- (void)tabItemAction:(UIButton*)btn{
    
    if(_selectedIndex == btn.tag)
        return ;
    
    Heqingzhao_MultiChannelConfig* item = nil;
    if([self.barDelegate respondsToSelector:@selector(topBar:willSelectIndex:item:)]){
        item = [self.arrayTabItem objectAtIndex:btn.tag];
        [self.barDelegate topBar:self willSelectIndex:btn.tag item:item];
    }

    [self setSelectedIndex:btn.tag animated:YES];
    
    if([self.barDelegate respondsToSelector:@selector(topBar:didSelectIndex:item:)]){
        [self.barDelegate topBar:self didSelectIndex:btn.tag item:item];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if(_selectedIndex == selectedIndex)
        return ;
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    if(selectedIndex < 0 || selectedIndex >= self.arrayTabItem.count)
        return ;
    
    Heqingzhao_MultiChannelConfig* preItem = nil;
    UIButton* preBtn = nil;
    if(_selectedIndex >= 0 && _selectedIndex < self.arrayTabItem.count){
        preItem = [self.arrayTabItem objectAtIndex:_selectedIndex];
        preBtn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
        preBtn.selected = NO;
        preBtn.titleLabel.font = preItem.topBarConfig.normalFont;
        preItem.status = 0;
    }
    
    _selectedIndex = selectedIndex;
    
    Heqingzhao_MultiChannelConfig* item = [self.arrayTabItem objectAtIndex:_selectedIndex];
    UIButton* btn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
    item.status = 1;
    btn.selected = YES;
    btn.titleLabel.font = item.topBarConfig.selectedFont;

    if(animated){

        [UIView beginAnimations:@"lineview_animation" context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.animateLineView.frame = CGRectMake(btn.left, self.animateLineView.y, btn.width, self.animateLineView.height);
        preBtn.layer.transform = CATransform3DIdentity;
        btn.layer.transform = CATransform3DScale(CATransform3DIdentity, item.topBarConfig.selectedScale, item.topBarConfig.selectedScale, 1);
        
        [UIView commitAnimations];
        [Heqingzhao_TabbarAdjustPosition showHiddenTabWith:btn splitDis:self.tabItemSpace containerScrollView:_tabItemScrollView animation:YES];
    }else{
        self.animateLineView.frame = CGRectMake(btn.left, self.animateLineView.y, btn.width, self.animateLineView.height);
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        preBtn.layer.transform = CATransform3DIdentity;
        btn.layer.transform = CATransform3DScale(CATransform3DIdentity, item.topBarConfig.selectedScale, item.topBarConfig.selectedScale, 1);
        [CATransaction commit];
        
        [Heqingzhao_TabbarAdjustPosition showHiddenTabWith:btn splitDis:self.tabItemSpace containerScrollView:_tabItemScrollView animation:NO];
    }
    
}

- (UIView *)animateLineView{
    if(!_animateLineView){
        
        UIButton* btn = [self.arrayTabButtons objectAtIndex:self.selectedIndex];
        _animateLineView = [[UIView alloc] initWithFrame:CGRectMake(btn.left, _tabItemScrollView.height - self.animateLineViewDis - 2, btn.width, 2)];
        _animateLineView.backgroundColor = [UIColor blueColor];
        [_tabItemScrollView addSubview:_animateLineView];
    }
    return _animateLineView;
}

- (void)setAnimateLineViewDis:(CGFloat)animateLineViewDis{
    _animateLineViewDis = animateLineViewDis;
    if(_animateLineView){
        _animateLineView.bottom = _tabItemScrollView.height - animateLineViewDis;
    }
}

- (void)setTabItemLayout:(Heqingzhao_MultiChannelTopBarLayout)tabItemLayout{
    if(_tabItemLayout == tabItemLayout)
        return ;
    
    _tabItemLayout = tabItemLayout;
    [self buildTabItems];
}

- (void)setArrayTabItem:(NSArray *)arrayTabItem{
    if([_arrayTabItem isEqualToArray:arrayTabItem])
        return ;
    
    _arrayTabItem = arrayTabItem;
    [self buildTabItems];
    
    if(self.customRightView){
        self.customRightView.frame = CGRectMake(self.customRightView.left, self.height - _tabItemScrollView.height - self.itemBottomDistance*2, self.customRightView.width, _tabItemScrollView.height + self.itemBottomDistance*2);
    }
}

- (void)setItemBottomDistance:(CGFloat)itemBottomDistance{
    
    CGFloat fRightHeight = 0;
    if(_tabItemScrollView){
        _tabItemScrollView.frame = CGRectMake(_tabItemScrollView.left, self.height - itemBottomDistance*2 + [self tabItemMaxHeight], _tabItemScrollView.width, itemBottomDistance*2 + [self tabItemMaxHeight]);
        fRightHeight = _tabItemScrollView.height;
    }
    _itemBottomDistance = itemBottomDistance;
    if(self.customRightView){
        if(0 == fRightHeight){
            fRightHeight =  self.rightItemImage.size.height;
        }
        self.customRightView.frame = CGRectMake(self.customRightView.left, self.height - fRightHeight, self.customRightView.width, fRightHeight);
    }
}

- (CGFloat)edgeSpace{
    if(0 == _edgeSpace){
        return _tabItemSpace;
    }
    return _edgeSpace;
}

- (void)setTabItemSpace:(CGFloat)tabItemSpace{
    if(_tabItemScrollView){
        CGFloat fPosX = tabItemSpace;
        for(UIView* btn in self.arrayTabButtons){
            btn.frame = CGRectMake(fPosX, btn.y, btn.width, btn.height);
            fPosX += btn.width + tabItemSpace;
        }
    }
    _tabItemSpace = tabItemSpace;
}

- (void)setRightItemWidth:(CGFloat)rightItemWidth{
    if(_tabItemScrollView){
        _tabItemScrollView.right = self.width - rightItemWidth;
        [self buildTabItems];
    }
    _rightItemWidth = rightItemWidth;
    if(self.customRightView){
        self.customRightView.width = rightItemWidth;
    }
}

- (void)setRightItemImage:(UIImage *)rightItemImage{
    if(self.customRightView && !_rightItemImage)
        return ;
    
    _rightItemImage = rightItemImage;
    
    CGFloat fHeight = 0;
    if(_tabItemScrollView){
        fHeight = _tabItemScrollView.height;
    }
    else{
        fHeight += rightItemImage.size.height;
    }
    
    CGFloat fWidth = self.rightItemWidth;
    if(0 == fWidth){
        fWidth = rightItemImage.size.width;
        [self setRightItemWidth:fWidth];
    }
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - fWidth, self.height - fHeight, fWidth, fHeight)];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customRightView removeFromSuperview];
    self.customRightView = btn;
}

- (void)rightItemAction:(UIButton*)btn{
    if([self.barDelegate respondsToSelector:@selector(rightItemAction:)]){
        [self.barDelegate rightItemAction:btn arrayItems:self.arrayTabItem];
    }
}

- (void)setupScrollFrame:(CGRect)frame{
    if(CGRectEqualToRect(self.tabItemScrollView.frame, frame))
        return ;
    
    self.tabItemScrollView.frame = frame;
    [self buildTabItems];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupScrollFrame:CGRectMake(0, self.height - self.tabItemScrollView.height, self.width - self.rightItemWidth, self.tabItemScrollView.height)];
    self.customRightView.frame = CGRectMake(self.width - self.customRightView.width, self.height - self.customRightView.height, self.customRightView.width, self.customRightView.height);
}

@end
