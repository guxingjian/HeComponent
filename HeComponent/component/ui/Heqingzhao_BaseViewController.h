//
//  Heqingzhao_BaseViewController.h
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_TableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Heqingzhao_BaseViewController : UIViewController

// 当系统导航栏隐藏后，是否自动创建导航栏
@property(nonatomic,assign)BOOL disableDefaultNavibar;
@property(nonatomic,assign)UINavigationBar* defaultNavibar;

// frame为safeAreaRect的tableView，懒加载
@property(nonatomic,strong)UITableView* safeAreaTableView;
@property(nonatomic,strong)Heqingzhao_TableViewController* tableController;

@end

NS_ASSUME_NONNULL_END
