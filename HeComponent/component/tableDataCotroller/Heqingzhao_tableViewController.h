//
//  Heqingzhao_tableController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_tableViewSectionConfig.h"

@interface Heqingzhao_tableViewController : NSObject<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView* tableView;

// 只有一个section并且都是cell可以只设置arrayCells
@property(nonatomic, strong)NSArray<Heqingzhao_tableViewCellConfig*>* arrayCells;

// 当有多个section或者只有单个section但是section有header或footer
// 设置arraySections后会忽略arrayCells数据
@property(nonatomic, strong)NSArray<Heqingzhao_tableViewSectionConfig*>* arraySections;

- (void)reloadData;

@end
