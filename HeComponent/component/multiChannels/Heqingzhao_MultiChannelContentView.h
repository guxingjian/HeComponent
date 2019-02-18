//
//  Heqingzhao_MultiChannelContentView.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/18.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_MultiChannelConfig.h"

@class Heqingzhao_MultiChannelContentView;

@protocol Heqingzhao_MultiChannelContentViewDelegate <NSObject>
@required

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView*)contentView willSelectIndex:(NSInteger)nIndex withChannelView:(UIView*)view andConfig:(Heqingzhao_MultiChannelConfig*)config;
- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView*)contentView didSelectIndex:(NSInteger)nIndex withChannelView:(UIView*)view andConfig:(Heqingzhao_MultiChannelConfig*)config;
- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView*)contentView scrollingWithIndex:(CGFloat)fIndex;

@end

@interface Heqingzhao_MultiChannelContentView : UIView

@property(nonatomic, weak)id<Heqingzhao_MultiChannelContentViewDelegate> delegate;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, strong)IBOutletCollection(Heqingzhao_MultiChannelConfig)NSArray* arrayTabItem;

@end
