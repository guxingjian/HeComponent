//
//  Heqz_MultiChannelContentView.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/18.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqz_MultiChannelConfig.h"

@class Heqz_MultiChannelContentView;

@protocol Heqz_MultiChannelContentViewDelegate <NSObject>
@optional

// Heqz_MultiChannelContentView 有预加载的功能，当选中index 2后，会调用willSelectIndex:2 然后调用willSelectIndex:1 在调用willSelectIndex:3
// 可以在这个方法中对view的界面进行修改或做一些网络数据请求等操作
- (void)multiChannelContentView:(Heqz_MultiChannelContentView*)contentView willSelectIndex:(NSInteger)nIndex withChannelView:(UIView*)view andConfig:(Heqz_MultiChannelConfig*)config;

- (void)multiChannelContentView:(Heqz_MultiChannelContentView*)contentView didSelectIndex:(NSInteger)nIndex withChannelView:(UIView*)view andConfig:(Heqz_MultiChannelConfig*)config;
- (void)multiChannelContentView:(Heqz_MultiChannelContentView*)contentView scrollingWithIndex:(CGFloat)fIndex;

@end

@interface Heqz_MultiChannelContentView : UIView

@property(nonatomic, weak)id<Heqz_MultiChannelContentViewDelegate> delegate;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, strong)NSArray* arrayTabItem;

// 默认为NO，指定selectedIndex时，总是会调用对应的config的contentProvider的代理方法获取contentView
// 如果设置为YES，会通过config的contentResuseIdentifier，复用已有contentView
@property(nonatomic, assign)BOOL enableReuseContentView;

@end
