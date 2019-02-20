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

@interface Heqingzhao_MultiChannelEditViewController : UIViewController

@property(nonatomic, weak)id<Heqingzhao_MultiChannelEditViewControllerDelegate> delegate;
@property(nonatomic, strong)NSArray<Heqingzhao_MultiChannelConfig*>* selectedTabConfigs; // 显示在topBar顶部的频道配置
@property(nonatomic, strong)NSArray<Heqingzhao_MultiChannelConfig*>* unselectedTabConfigs; // 没有显示的频道配置

// 中间运算数据，不能修改
@property(nonatomic, readonly)NSIndexPath* movingIndexPath;
@property(nonatomic, readonly)NSMutableArray* tempSelectedTabConfigs;
@property(nonatomic, readonly)NSMutableArray* tempUnselectedTabConfigs;

- (NSIndexPath*)findTargetIndexPath:(CGPoint)pt;// 当将选择的频道拖动到不选择的频道中时，使用这个方法返回适当的indexPath

@end
