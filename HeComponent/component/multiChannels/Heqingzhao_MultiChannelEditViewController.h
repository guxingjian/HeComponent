//
//  Heqingzhao_MultiChannelEditViewController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/19.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Heqingzhao_MultiChannelConfig.h"

@protocol Heqingzhao_MultiChannelEditViewControllerDelegate <NSObject>

- (void)saveSelectedConfig:(NSArray*)selectedConfig unSelectedConfig:(NSArray*)unSelectedConfig;

@end

@interface Heqingzhao_MultiChannelEditViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property(nonatomic, weak)id<Heqingzhao_MultiChannelEditViewControllerDelegate> delegate;
@property(nonatomic, strong)NSArray<Heqingzhao_MultiChannelConfig*>* selectedTabConfigs; // 显示在topBar顶部的频道配置
@property(nonatomic, strong)NSArray<Heqingzhao_MultiChannelConfig*>* unselectedTabConfigs; // 没有显示的频道配置

@end
