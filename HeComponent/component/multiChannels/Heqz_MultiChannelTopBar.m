//
//  Heqz_MultiChannelTopBar.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_MultiChannelTopBar.h"
#import "UIView+view_frame.h"
#import "Heqz_TabbarAdjustPosition.h"
#import "Heqz_ImageLoader.h"

@interface Heqz_MultiChannelTopBar()

@property(nonatomic, strong)UIScrollView* tabItemScrollView;
@property(nonatomic, readwrite)NSMutableArray* arrayTabButtons;

@end

@implementation Heqz_MultiChannelTopBar

@synthesize edgeSpace = _edgeSpace;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.rightItemWidth = 50;
        self.rightItemImage = [Heqz_ImageLoader loadImage:@"down_arrow"];
        _selectedIndex = -1;
//        self.backgroundColor = [UIColor colorWithHexString:@"#F3F4F9"];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.rightItemWidth = 50;
    self.rightItemImage = [Heqz_ImageLoader loadImage:@"down_arrow"];
    _selectedIndex = -1;
//    self.backgroundColor = [UIColor colorWithHexString:@"#F3F4F9"];
}

- (NSMutableArray *)arrayTabButtons{
    if(!_arrayTabButtons){
        _arrayTabButtons = [NSMutableArray array];
    }
    return _arrayTabButtons;
}

- (CGFloat)tabItemMaxHeight{
    if(_arrayTabItem.count > 0){
        Heqz_MultiChannelConfig* tabItem = _arrayTabItem.firstObject;
        return tabItem.topBarConfig.maxHeight;
    }
    return 0;
}

- (UIButton*)buildTabItems
{
    NSArray* arrayTabItem = self.arrayTabItem;
    if(arrayTabItem.count == 0)
        return nil;
    
    CGFloat fScrollHeight = self.itemBottomDistance*2;
    fScrollHeight += [self tabItemMaxHeight];
    
    if(!_tabItemScrollView){
        _tabItemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.height - fScrollHeight, self.width - self.rightItemWidth, fScrollHeight)];
        _tabItemScrollView.showsVerticalScrollIndicator = NO;
        _tabItemScrollView.showsHorizontalScrollIndicator = NO;
        _tabItemScrollView.alwaysBounceHorizontal = YES;
        [self addSubview:_tabItemScrollView];
    }
    
    CGFloat fPosX = self.edgeSpace;
    UIButton* selectedBtn = nil;
    for(NSInteger i = 0; i < arrayTabItem.count; ++ i){
        UIButton* btnTab = nil;
        if(i < self.arrayTabButtons.count){
            btnTab = [self.arrayTabButtons objectAtIndex:i];
            btnTab.layer.transform = CATransform3DIdentity;
        }
        else{
            btnTab = [[UIButton alloc] initWithFrame:CGRectZero];
            btnTab.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.arrayTabButtons addObject:btnTab];
        }
        
        btnTab.tag = i;
        Heqz_MultiChannelConfig* item = [arrayTabItem objectAtIndex:i];
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
            btnTab.layer.transform = CATransform3DScale(CATransform3DIdentity, item.topBarConfig.selectedScale, item.topBarConfig.selectedScale, 1);
        }
        btnTab.selected = item.status;
        
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
    if(self.arrayTabButtons.count > arrayTabItem.count){
        for(NSInteger i = arrayTabItem.count; i < self.arrayTabButtons.count; ++ i){
            UIView* view = [self.arrayTabButtons objectAtIndex:i];
            [view removeFromSuperview];
        }
        self.arrayTabButtons = [NSMutableArray arrayWithArray:[self.arrayTabButtons subarrayWithRange:NSMakeRange(0, arrayTabItem.count)]];
    }
    
    if(Heqz_MultiChannelTopBarLayout_Divide == self.tabItemLayout && self.arrayTabButtons.count > 0 && fPosX <= _tabItemScrollView.width){
        CGFloat fSplit = _tabItemScrollView.width /self.arrayTabButtons.count;
        for(NSInteger i = 0; i < self.arrayTabButtons.count; ++ i){
            UIView* btn = [self.arrayTabButtons objectAtIndex:i];
            btn.frame = CGRectMake(i*fSplit + fSplit/2 - btn.width, btn.y, btn.width, btn.height);
        }
    }
    
    if(fPosX < _tabItemScrollView.width){
        fPosX = _tabItemScrollView.width;
    }
    _tabItemScrollView.contentSize = CGSizeMake(fPosX, 0);
    
    if(!selectedBtn){
        selectedBtn = self.arrayTabButtons.firstObject;
    }
    return selectedBtn;
}

- (void)tabItemAction:(UIButton*)btn{
    [self setSelectedIndex:btn.tag];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if(_selectedIndex == selectedIndex)
        return ;
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)indexChangedAnimationWithPreIndex:(NSInteger)preIndex{
    UIButton* preBtn = nil;
    if(preIndex >= 0 && preIndex < self.arrayTabButtons.count){
        preBtn = [self.arrayTabButtons objectAtIndex:preIndex];
    }
    
    Heqz_MultiChannelConfig* item = [self.arrayTabItem objectAtIndex:_selectedIndex];
    UIButton* btn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
    [UIView beginAnimations:@"lineview_animation" context:nil];
    [UIView setAnimationDuration:0.3];
    
    if(!self.hideAnimatedLine){
        self.animateLineView.frame = CGRectMake(btn.left, self.animateLineView.y, btn.width, self.animateLineView.height);
    }
    
    preBtn.layer.transform = CATransform3DIdentity;
    btn.layer.transform = CATransform3DScale(CATransform3DIdentity, item.topBarConfig.selectedScale, item.topBarConfig.selectedScale, 1);
    
    [UIView commitAnimations];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    if(selectedIndex < 0 || selectedIndex >= self.arrayTabItem.count)
        return ;
    
    Heqz_MultiChannelConfig* preItem = nil;
    UIButton* preBtn = nil;
    if(_selectedIndex >= 0 && _selectedIndex < self.arrayTabItem.count){
        preItem = [self.arrayTabItem objectAtIndex:_selectedIndex];
        preBtn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
        [preBtn setTitleColor:preItem.topBarConfig.normalTextColor forState:UIControlStateNormal];
        [preBtn setTitleColor:preItem.topBarConfig.selectedTextColor forState:UIControlStateSelected];
        preBtn.selected = NO;
        preBtn.titleLabel.font = preItem.topBarConfig.normalFont;
        preItem.status = 0;
    }
    
    Heqz_MultiChannelConfig* item = [self.arrayTabItem objectAtIndex:selectedIndex];
    if([self.delegate respondsToSelector:@selector(topBar:willSelectIndex:item:)]){
        [self.delegate topBar:self willSelectIndex:selectedIndex item:item];
    }
    
    NSInteger preIndex = _selectedIndex;
    _selectedIndex = selectedIndex;

    UIButton* btn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
    item.status = 1;
    [btn setTitleColor:item.topBarConfig.normalTextColor forState:UIControlStateNormal];
    [btn setTitleColor:item.topBarConfig.selectedTextColor forState:UIControlStateSelected];
    btn.selected = YES;
    btn.titleLabel.font = item.topBarConfig.selectedFont;

    if(animated){
        [self indexChangedAnimationWithPreIndex:preIndex];
        [Heqz_TabbarAdjustPosition showHiddenTabWith:btn splitDis:self.tabItemSpace containerScrollView:_tabItemScrollView animation:YES];
    }else{
        self.animateLineView.frame = CGRectMake(btn.left, self.animateLineView.y, btn.width, self.animateLineView.height);
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        preBtn.layer.transform = CATransform3DIdentity;
        btn.layer.transform = CATransform3DScale(CATransform3DIdentity, item.topBarConfig.selectedScale, item.topBarConfig.selectedScale, 1);
        [CATransaction commit];
        
        [Heqz_TabbarAdjustPosition showHiddenTabWith:btn splitDis:self.tabItemSpace containerScrollView:_tabItemScrollView animation:NO];
    }
    if([self.delegate respondsToSelector:@selector(topBar:didSelectIndex:item:)]){
        [self.delegate topBar:self didSelectIndex:_selectedIndex item:item];
    }
}

- (void)setHideAnimatedLine:(BOOL)hideAnimatedLine{
    self.animateLineView.hidden = YES;
}

- (UIView *)animateLineView{
    if(!_animateLineView){
        
        UIButton* btn = nil;
        if(_selectedIndex >= 0 && _selectedIndex < self.arrayTabButtons.count){
            btn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
        }
        _animateLineView = [[UIView alloc] initWithFrame:CGRectMake(btn.left, _tabItemScrollView.height - self.animateLineViewDis - 2, btn.width, 2)];
        _animateLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
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

- (void)setTabItemLayout:(Heqz_MultiChannelTopBarLayout)tabItemLayout{
    if(_tabItemLayout == tabItemLayout)
        return ;
    
    _tabItemLayout = tabItemLayout;
    [self buildTabItems];
}

- (void)setArrayTabItem:(NSArray *)arrayTabItem{
    if([_arrayTabItem isEqualToArray:arrayTabItem])
        return ;
    
    _arrayTabItem = arrayTabItem;
    UIButton* selectedBtn = [self buildTabItems];
    if(selectedBtn){
        [self setSelectedIndex:selectedBtn.tag animated:NO];
    }
    if(self.customRightView){
        self.customRightView.frame = CGRectMake(self.customRightView.x, _tabItemScrollView.y, self.customRightView.width, _tabItemScrollView.height);
    }
}

- (void)setItemBottomDistance:(CGFloat)itemBottomDistance{
    if(_tabItemScrollView){
        _tabItemScrollView.frame = CGRectMake(_tabItemScrollView.left, self.height - itemBottomDistance*2 + [self tabItemMaxHeight], _tabItemScrollView.width, itemBottomDistance*2 + [self tabItemMaxHeight]);
        if(self.customRightView){
            self.customRightView.frame = CGRectMake(self.customRightView.left, _tabItemScrollView.y, self.customRightView.width, _tabItemScrollView.height);
        }
    }
    _itemBottomDistance = itemBottomDistance;
}

- (CGFloat)edgeSpace{
    if(0 == _edgeSpace){
        return 15;
    }
    return _edgeSpace;
}

- (void)setEdgeSpace:(CGFloat)edgeSpace{
    _edgeSpace = edgeSpace;
    if(_tabItemScrollView){
        [self buildTabItems];
    }
}

- (void)setTabItemSpace:(CGFloat)tabItemSpace{
    if(_tabItemScrollView){
        CGFloat fPosX = self.edgeSpace;
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
//    if(self.customRightView && !_rightItemImage)
//        return ;
//
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
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customRightView removeFromSuperview];
    self.customRightView = btn;
}

- (void)rightItemAction:(UIButton*)btn{
    if([self.delegate respondsToSelector:@selector(topBar:rightItemAction:arrayItems:)]){
        [self.delegate topBar:self rightItemAction:btn arrayItems:self.arrayTabItem];
    }
}

- (void)setupScrollFrame:(CGRect)frame{
    if(CGRectEqualToRect(self.tabItemScrollView.frame, frame))
        return ;
    
    self.tabItemScrollView.frame = frame;
    [self buildTabItems];
}

- (void)scrollToIndex:(CGFloat)fIndex gradient:(BOOL)gradient{
    NSInteger nTargetIndex = -1;
    CGFloat fScale = 0;
    
    if(fIndex > _selectedIndex){
        nTargetIndex = _selectedIndex + 1;
        fScale = fIndex - _selectedIndex;
    }else if(fIndex < _selectedIndex){
        nTargetIndex = _selectedIndex - 1;
        fScale = _selectedIndex - fIndex;
    }
    
    if(nTargetIndex < 0 || nTargetIndex >= self.arrayTabButtons.count)
        return ;
    if(_selectedIndex < 0 || _selectedIndex >= self.arrayTabButtons.count)
        return ;
    
    UIButton* targetBtn = [self.arrayTabButtons objectAtIndex:nTargetIndex];
    UIButton* currentBtn = [self.arrayTabButtons objectAtIndex:_selectedIndex];
    
    if(!self.hideAnimatedLine){
        CGFloat fMaxWidth = targetBtn.center.x - currentBtn.center.x;
        if(fMaxWidth < 0){
            fMaxWidth = -fMaxWidth;
        }
        if(fMaxWidth > 50){
            fMaxWidth = 50;
        }
        
        CGFloat fLineW = 0;
        if(fScale <= 0.5){
            fLineW = 4*(currentBtn.width - fMaxWidth)*(fScale - 0.5)*(fScale-0.5) + fMaxWidth;
        }else{
            fLineW = 4*(targetBtn.width - fMaxWidth)*(fScale - 0.5)*(fScale-0.5) + fMaxWidth;
        }
        
        CGFloat fPosX = 0;
        if(fIndex < _selectedIndex){
            fPosX = (currentBtn.x - targetBtn.x)*(fScale-1)*(fScale-1) + targetBtn.x;
        }else {
            CGFloat fRight = (currentBtn.right - targetBtn.right)*(fScale-1)*(fScale-1) + targetBtn.right;
            fPosX = fRight - fLineW;
        }
        self.animateLineView.frame = CGRectMake(fPosX, self.animateLineView.y, fLineW, self.animateLineView.height);
    }
    
    if(gradient){
        Heqz_MultiChannelConfig* currentConfig = [self.arrayTabItem objectAtIndex:_selectedIndex];
        Heqz_MultiChannelConfig* targetConfig = [self.arrayTabItem objectAtIndex:nTargetIndex];
        CGFloat fCurrentScale = [self originValue:currentConfig.topBarConfig.selectedScale targetValue:1 xFac:fScale];
        CGFloat fTargetScale = [self originValue:1 targetValue:targetConfig.topBarConfig.selectedScale xFac:fScale];
        currentBtn.layer.transform = CATransform3DScale(CATransform3DIdentity, fCurrentScale, fCurrentScale, 1);
        targetBtn.layer.transform = CATransform3DScale(CATransform3DIdentity, fTargetScale, fTargetScale, 1);
        
        CGFloat currentSelectedColorBuffer[4] = {};
        [currentConfig.topBarConfig.selectedTextColor getRed:(CGFloat*)currentSelectedColorBuffer green:(CGFloat*)currentSelectedColorBuffer + 1 blue:(CGFloat*)currentSelectedColorBuffer + 2 alpha:(CGFloat*)currentSelectedColorBuffer + 3];
        CGFloat currentNormalBuffer[4] = {};
        [currentConfig.topBarConfig.normalTextColor getRed:(CGFloat*)currentNormalBuffer green:(CGFloat*)currentNormalBuffer + 1 blue:(CGFloat*)currentNormalBuffer + 2 alpha:(CGFloat*)currentNormalBuffer + 3];
        UIColor* currentColor = [UIColor colorWithRed:[self originValue:currentSelectedColorBuffer[0] targetValue:currentNormalBuffer[0] xFac:fScale] green:[self originValue:currentSelectedColorBuffer[1] targetValue:currentNormalBuffer[1] xFac:fScale] blue:[self originValue:currentSelectedColorBuffer[2] targetValue:currentNormalBuffer[2] xFac:fScale] alpha:1];
        [currentBtn setTitleColor:currentColor forState:UIControlStateSelected];
        
        CGFloat targetSelectedColorBuffer[4] = {};
        [targetConfig.topBarConfig.selectedTextColor getRed:(CGFloat*)targetSelectedColorBuffer green:(CGFloat*)targetSelectedColorBuffer + 1 blue:(CGFloat*)targetSelectedColorBuffer + 2 alpha:(CGFloat*)targetSelectedColorBuffer + 3];
        CGFloat targetNormalBuffer[4] = {};
        [targetConfig.topBarConfig.normalTextColor getRed:(CGFloat*)targetNormalBuffer green:(CGFloat*)targetNormalBuffer + 1 blue:(CGFloat*)targetNormalBuffer + 2 alpha:(CGFloat*)targetNormalBuffer + 3];
        UIColor* targetColor = [UIColor colorWithRed:[self originValue:targetNormalBuffer[0] targetValue:targetSelectedColorBuffer[0] xFac:fScale] green:[self originValue:targetNormalBuffer[1] targetValue:targetSelectedColorBuffer[1] xFac:fScale] blue:[self originValue:targetNormalBuffer[2] targetValue:targetSelectedColorBuffer[2] xFac:fScale] alpha:1];
        [targetBtn setTitleColor:targetColor forState:UIControlStateNormal];
    }
}
                                                  
- (CGFloat)originValue:(CGFloat)sv targetValue:(CGFloat)tv xFac:(CGFloat)fScale{
    return (tv - sv)*fScale + sv;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupScrollFrame:CGRectMake(0, self.height - self.tabItemScrollView.height, self.width - self.rightItemWidth, self.tabItemScrollView.height)];
    
    CGRect rtCustom = CGRectMake(self.width - self.customRightView.width, self.height - self.customRightView.height, self.customRightView.width, self.customRightView.height);
    if(!CGRectEqualToRect(rtCustom, self.customRightView.frame)){
        self.customRightView.frame = rtCustom;
    }
}

- (void)setSelectedIndexWithComparion:(BOOL (^)(Heqz_MultiChannelConfig* config))compareBlock{
    [self setSelectedIndexWithComparion:compareBlock animated:NO];
}

- (void)setSelectedIndexWithComparion:(BOOL (^)(Heqz_MultiChannelConfig* config))compareBlock animated:(BOOL)animated{
    NSInteger nIndex = -1;
    for(NSInteger i = 0; i < self.arrayTabItem.count; ++ i){
        Heqz_MultiChannelConfig* config = [self.arrayTabItem objectAtIndex:i];
        if(compareBlock(config)){
            nIndex = i;
            break;
        }
    }
    if(nIndex != -1 && nIndex != self.selectedIndex){
        [self setSelectedIndex:nIndex animated:animated];
    }
}

@end
