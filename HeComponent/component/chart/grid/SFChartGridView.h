//
//  SFChartGridView.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/24.
//  Copyright © 2018年 qingzhao. All rights reserved.
//
// 表格的视图
// 默认提供SFChartGrid表格
// 也可设置其他类型的表格
//

#import "SFChartView.h"
#import "SFChartGrid.h"

@class SFChartGridView;

// 优先使用SFChartGrid的selectGridCell block回调
@protocol SFChartGridViewProtocol <NSObject>

- (void)chartGridView:(SFChartGridView*)gridView selectGridCell:(SFChartGrid*)gridCell withLocation:(CGPoint)pt;

@end

@interface SFChartGridView : SFChartView

@property(nonatomic, strong)SFChartGrid* grid;
@property(nonatomic, weak)id<SFChartGridViewProtocol> gridDelegate;

- (instancetype)initWithFrame:(CGRect)frame grid:(SFChartGrid*)grid;

- (void)removeGridData;
- (void)showGridData;

@end
