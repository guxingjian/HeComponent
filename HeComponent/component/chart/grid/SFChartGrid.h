//
//  SFChartGrid.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//


// 表格中所有坐标都以左上角为坐标原点
// 数据结构为行优先
// @[ @[col00, col01, ...],
//    @[col10, col11, ...],
//    .
//    .
//    .
//  ]
//
//  通用表格，可实现任意形式的表格。 使用SFChartElement绘制表格中元素
//  
//

#import <Foundation/Foundation.h>
#import "SFChartChart.h"
#import "SFChartPointCollection.h"

@interface SFChartGridCellIndex : NSObject

@property(nonatomic, assign)NSInteger nRow;
@property(nonatomic, assign)NSInteger nCol;

+ (instancetype)indexWithRow:(NSInteger)row column:(NSInteger)col;
- (BOOL)equalToindex:(SFChartGridCellIndex*)index;

@end

@interface SFChartGrid : NSObject

@property(nonatomic, assign)CGRect boundRect;
@property(nonatomic, strong)NSArray<SFChartElement*> * arrayContent;
@property(nonatomic, strong)SFChartGridCellIndex* cellIndex;
@property(nonatomic, strong)NSMutableArray* subGrids;
@property(nonatomic, assign)CGFloat lineWidth;
@property(nonatomic, strong)UIColor* lineColor;
@property(nonatomic, assign)BOOL enableRelativePosition;
@property(nonatomic, strong)id userInfo;
@property(nonatomic, strong)void (^selectGridCell)(CGPoint pt);

+ (instancetype)grid;

- (SFChartGrid*)gridAtIndex:(SFChartGridCellIndex*)index;
- (void)addElementsWithChart:(SFChartChart*)chart;
- (SFChartPointCollection*)subGridBoundingPoints:(SFChartGrid*)subGrid;
- (void)clearContent;
- (SFChartGrid*)gridCellWithLocation:(CGPoint)pt;

@end
