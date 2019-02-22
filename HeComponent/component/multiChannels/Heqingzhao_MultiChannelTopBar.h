//
//  Heqingzhao_MultiChannelTopBar.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_MultiChannelConfig.h"

@class Heqingzhao_MultiChannelTopBar;

@protocol Heqingzhao_MultiChannelTopBarDelegate <NSObject>

@optional
- (void)topBar:(Heqingzhao_MultiChannelTopBar*)topBar willSelectIndex:(NSInteger)index item:(Heqingzhao_MultiChannelConfig*)item;
- (void)topBar:(Heqingzhao_MultiChannelTopBar*)topBar didSelectIndex:(NSInteger)index item:(Heqingzhao_MultiChannelConfig*)item;
- (void)topBar:(Heqingzhao_MultiChannelTopBar*)topBar rightItemAction:(UIButton*)btn arrayItems:(NSArray*)arrayItems;

@end

typedef NS_OPTIONS(NSInteger, Heqingzhao_MultiChannelTopBarLayout){
    Heqingzhao_MultiChannelTopBarLayout_Auto,// 按照个数和间距，从左向右排列
    Heqingzhao_MultiChannelTopBarLayout_Divide // 按个数平分，如果个数太多，超出宽度，调整为auto
    
};

@interface Heqingzhao_MultiChannelTopBar : UIView

@property(nonatomic, weak)id<Heqingzhao_MultiChannelTopBarDelegate> delegate;

// 为了提高效率， 请在设置完下边所需参数后再设置arrayTabItem，因为在设置arrayTabItem的时候会创建tabItem
@property(nonatomic, strong)NSArray* arrayTabItem;

@property(nonatomic, strong)UIImage* rightItemImage; // 如果设置了，使用rightItemImage创建一个按钮
@property(nonatomic, assign)CGFloat rightItemWidth; // rightItem的宽度
@property(nonatomic, strong)UIView* customRightView; // 设置后，在bar右侧展示，会覆盖掉rightItemImage的按钮

@property(nonatomic, assign)CGFloat itemBottomDistance;


@property(nonatomic, assign)CGFloat tabItemSpace;// 第一个item距离左边为edgeSpace，item之间的间距为tabItemSpace
@property(nonatomic, assign)CGFloat edgeSpace;//第一个item和最后一个item距离边界的距离，默认为tabItemSpace

@property(nonatomic, assign)BOOL hideAnimatedLine; // 选中标题下边的横线是否隐藏
@property(nonatomic, assign)CGFloat animateLineViewDis; // 设置lineView距离底部的距离
@property(nonatomic, strong)UIView* animateLineView; // 如果设置了，使用rightItemImage创建一个按钮
@property(nonatomic, assign)NSInteger selectedIndex;

@property(nonatomic, assign)Heqingzhao_MultiChannelTopBarLayout tabItemLayout;
@property(nonatomic, readonly)NSMutableArray* arrayTabButtons;

// 方法中不会检查设置的selectedIndex和原来的selectedIndex是否相等，需要自己判断
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

- (CGFloat)tabItemMaxHeight; // 获取tab的最大高度，可以由子类重写

// 可以由子类重写 自定义动画
- (void)indexChangedAnimationWithPreIndex:(NSInteger)preIndex;

// 当contentView左右滑动的时候，必须调用这个函数，fIndex为浮点数的索引
// 可由子类重写，自定义行为
- (void)scrollToIndex:(CGFloat)fIndex;

@end
