//
//  Heqz_ChartGridView.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/24.
//  Copyright © 2018年 qingzhao. All rights reserved.
//
// 表格的视图
// 默认提供Heqz_ChartGrid表格
// 也可设置其他类型的表格
//

#import "Heqz_ChartView.h"
#import "Heqz_ChartGrid.h"

@class Heqz_ChartGridView;

// 优先使用Heqz_ChartGrid的selectGridCell block回调
@protocol Heqz_ChartGridViewProtocol <NSObject>

- (void)chartGridView:(Heqz_ChartGridView*)gridView selectGridCell:(Heqz_ChartGrid*)gridCell withLocation:(CGPoint)pt;

@end

@interface Heqz_ChartGridView : Heqz_ChartView

@property(nonatomic, strong)Heqz_ChartGrid* grid;
@property(nonatomic, weak)id<Heqz_ChartGridViewProtocol> gridDelegate;

- (instancetype)initWithFrame:(CGRect)frame grid:(Heqz_ChartGrid*)grid;

- (void)removeGridData;
- (void)showGridData;

@end
