//
//  Heqingzhao_tableController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_tableViewSectionConfig.h"
#import "Heqingzhao_loadingView.h"
#import "Heqingzhao_tableViewBaseCell.h"

@class Heqingzhao_tableViewController;

@protocol Heqingzhao_tableViewControllerDelegate <NSObject>

- (void)triggerTopLoadingWithTableController:(Heqingzhao_tableViewController*)tableController;

@end

@interface Heqingzhao_tableViewController : NSObject<UITableViewDataSource, UITableViewDelegate, Heqingzhao_tableViewBaseCellDelegate>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, weak)id<Heqingzhao_tableViewControllerDelegate> delegate;

// 只有一个section并且都是cell可以只设置arrayCells
@property(nonatomic, strong)NSArray<Heqingzhao_tableViewCellConfig*>* arrayCells;

// 当有多个section或者只有单个section但是section有header或footer
// 设置arraySections后会忽略arrayCells数据
@property(nonatomic, strong)NSArray<Heqingzhao_tableViewSectionConfig*>* arraySections;

@property(nonatomic, strong)Heqingzhao_loadingView* topLoadingView;
@property(nonatomic, strong)Heqingzhao_loadingView* bottomLoadingView;

- (void)reloadData;

// 调用后会使用handler回调, 而不是delegate
- (void)installTopLoadingView:(Heqingzhao_loadingView*)loadingView loadingHandler:(void(^)(void))handler;
- (void)installBottomLoadingView:(Heqingzhao_loadingView*)loadingView loadingHandler:(void(^)(void))handler;

@end
