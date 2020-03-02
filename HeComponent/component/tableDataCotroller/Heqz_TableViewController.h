//
//  Heqz_tableController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqz_TableViewSectionConfig.h"
#import "Heqz_loadingView.h"
#import "Heqz_TableViewBaseCell.h"

@class Heqz_TableViewController;

@protocol Heqz_TableViewControllerDelegate <NSObject>

- (void)triggerTopLoadingWithTableController:(Heqz_TableViewController*)tableController;
- (void)triggerBottomLoadingWithTableController:(Heqz_TableViewController*)tableController;
- (void)tableController:(Heqz_TableViewController*)controller tableCell:(Heqz_TableViewBaseCell*)cell doActionWithInfo:(id)info;

@end

@interface Heqz_TableViewController : NSObject<UITableViewDataSource, UITableViewDelegate, Heqz_TableViewBaseCellDelegate>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, weak)id<Heqz_TableViewControllerDelegate> delegate;

// 只有一个section并且都是cell可以只设置arrayCells
@property(nonatomic, strong)NSArray<Heqz_TableViewCellConfig*>* arrayCells;

// 当有多个section或者只有单个section但是section有header或footer
// 设置arraySections后会忽略arrayCells数据
@property(nonatomic, strong)NSArray<Heqz_TableViewSectionConfig*>* arraySections;

@property(nonatomic, strong)Heqz_LoadingView* topLoadingView;
@property(nonatomic, strong)Heqz_LoadingView* bottomLoadingView;


- (void)reloadData;

// 调用后会使用handler回调, 而不是delegate
- (void)installTopLoadingView:(Heqz_LoadingView*)loadingView loadingHandler:(void(^)(void))handler;
- (void)installBottomLoadingView:(Heqz_LoadingView*)loadingView loadingHandler:(void(^)(void))handler;

@end
