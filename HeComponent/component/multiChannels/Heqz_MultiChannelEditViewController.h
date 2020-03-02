//
//  Heqz_MultiChannelEditViewController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/19.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Heqz_MultiChannelConfig.h"

@protocol Heqz_MultiChannelEditViewControllerDelegate <NSObject>

- (void)saveSelectedConfig:(NSArray*)selectedConfig unSelectedConfig:(NSArray*)unSelectedConfig;

@end

@interface Heqz_MultiChannelEditViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property(nonatomic, weak)id<Heqz_MultiChannelEditViewControllerDelegate> delegate;
@property(nonatomic, strong)NSArray<Heqz_MultiChannelConfig*>* selectedTabConfigs; // 显示在topBar顶部的频道配置
@property(nonatomic, strong)NSArray<Heqz_MultiChannelConfig*>* unselectedTabConfigs; // 没有显示的频道配置

@end
