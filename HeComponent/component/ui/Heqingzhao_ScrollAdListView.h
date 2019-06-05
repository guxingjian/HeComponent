//
//  Heqingzhao_ScrollAdListView.h
//  HeComponent
//
//  Created by qingzhao on 2019/6/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_PageControl.h"

NS_ASSUME_NONNULL_BEGIN

@class Heqingzhao_ScrollAdListView;

@protocol Heqingzhao_ScrollAdListViewDelegate <NSObject>

- (void)adListView:(Heqingzhao_ScrollAdListView*)listView setupItemView:(UIView*)itemView itemIndex:(NSInteger)nIndex itemModel:(id)model;
- (void)adListView:(Heqingzhao_ScrollAdListView*)listView didSelectIndex:(NSInteger)nIndex itemModel:(id)model;

@end

@interface Heqingzhao_ScrollAdListView : UIView

@property(nonatomic, strong)NSArray* arrayItems;
@property(nonatomic, weak)id<Heqingzhao_ScrollAdListViewDelegate> delegate;
@property(nonatomic, strong)Heqingzhao_PageControl* pageControl;
 // 可滑动区域距离底部的距离，pageControl会在这个距离居中位置，如果距离小于pageControl的高度，
// pageControl会盖在滑动区域上
@property(nonatomic, assign)CGFloat scrollBottomEdge;
@property(nonatomic, assign)CGFloat fTimerInterval;
@property(nonatomic, assign)BOOL canScrollCirclable; // 是否能够循环滚动

- (void)reloadAdList;
- (void)destoryTimer;

@end

NS_ASSUME_NONNULL_END
