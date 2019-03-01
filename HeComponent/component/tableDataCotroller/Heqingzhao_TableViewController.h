//
//  Heqingzhao_tableController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_TableViewSectionConfig.h"
#import "Heqingzhao_loadingView.h"
#import "Heqingzhao_TableViewBaseCell.h"

@class Heqingzhao_TableViewController;

@protocol Heqingzhao_TableViewControllerDelegate <NSObject>

- (void)triggerTopLoadingWithTableController:(Heqingzhao_TableViewController*)tableController;
- (void)triggerBottomLoadingWithTableController:(Heqingzhao_TableViewController*)tableController;

@end

@interface Heqingzhao_TableViewController : NSObject<UITableViewDataSource, UITableViewDelegate, Heqingzhao_TableViewBaseCellDelegate>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, weak)id<Heqingzhao_TableViewControllerDelegate> delegate;

// 只有一个section并且都是cell可以只设置arrayCells
@property(nonatomic, strong)NSArray<Heqingzhao_TableViewCellConfig*>* arrayCells;

// 当有多个section或者只有单个section但是section有header或footer
// 设置arraySections后会忽略arrayCells数据
@property(nonatomic, strong)NSArray<Heqingzhao_TableViewSectionConfig*>* arraySections;

@property(nonatomic, strong)Heqingzhao_LoadingView* topLoadingView;
@property(nonatomic, strong)Heqingzhao_LoadingView* bottomLoadingView;

- (void)reloadData;

// 调用后会使用handler回调, 而不是delegate
- (void)installTopLoadingView:(Heqingzhao_LoadingView*)loadingView loadingHandler:(void(^)(void))handler;
- (void)installBottomLoadingView:(Heqingzhao_LoadingView*)loadingView loadingHandler:(void(^)(void))handler;

@end
