//
//  Heqz_BaseViewController.h
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqz_TableViewController.h"

@interface Heqz_BaseViewController : UIViewController<Heqz_TableViewControllerDelegate>

// 当系统导航栏隐藏后，是否自动创建导航栏
@property(nonatomic,assign)BOOL disableDefaultNavibar;
@property(nonatomic,strong)UINavigationBar* defaultNavibar;

// frame为safeAreaRect的tableView，懒加载
@property(nonatomic,strong)UITableView* safeAreaTableView;
@property(nonatomic,strong)Heqz_TableViewController* tableController;

- (void)viewWillAppearHandleTheme;
- (void)decorateView;

- (void)viewWillDisappearHandleTheme;

@end
