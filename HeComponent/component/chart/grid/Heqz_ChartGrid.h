//
//  Heqz_ChartGrid.h
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
//  通用表格，可实现任意形式的表格。 使用Heqz_ChartElement绘制表格中元素
//  
//

#import <Foundation/Foundation.h>
#import "Heqz_ChartChart.h"
#import "Heqz_ChartPointCollection.h"

@interface Heqz_ChartGridCellIndex : NSObject

@property(nonatomic, assign)NSInteger nRow;
@property(nonatomic, assign)NSInteger nCol;

+ (instancetype)indexWithRow:(NSInteger)row column:(NSInteger)col;
- (BOOL)equalToindex:(Heqz_ChartGridCellIndex*)index;

@end

@interface Heqz_ChartGrid : NSObject

@property(nonatomic, assign)CGRect boundRect;
@property(nonatomic, strong)NSArray<Heqz_ChartElement*> * arrayContent;
@property(nonatomic, strong)Heqz_ChartGridCellIndex* cellIndex;
@property(nonatomic, strong)NSMutableArray* subGrids;
@property(nonatomic, assign)CGFloat lineWidth;
@property(nonatomic, strong)UIColor* lineColor;
@property(nonatomic, assign)BOOL enableRelativePosition;
@property(nonatomic, strong)id userInfo;
@property(nonatomic, strong)void (^selectGridCell)(CGPoint pt);

+ (instancetype)grid;

- (Heqz_ChartGrid*)gridAtIndex:(Heqz_ChartGridCellIndex*)index;
- (void)addElementsWithChart:(Heqz_ChartChart*)chart;
- (Heqz_ChartPointCollection*)subGridBoundingPoints:(Heqz_ChartGrid*)subGrid;
- (void)clearContent;
- (Heqz_ChartGrid*)gridCellWithLocation:(CGPoint)pt;

@end
