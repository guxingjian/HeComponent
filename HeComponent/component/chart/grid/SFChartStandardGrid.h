//
//  SFChartCommonGrid.h
//  SinaFinance
//
//  Created by qingzhao on 2018/10/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//
//  定制表格，固定为nRow行nColumn列的标准表格
//  表格中的元素需要dataSource提供
//
#import "SFChartGrid.h"

@class SFChartStandardGrid;

@protocol SFChartStandardGridDataSource <NSObject>

- (NSArray<SFChartElement*>*)standardGrid:(SFChartStandardGrid*)gird elementsForGridIndex:(SFChartGridCellIndex*)cellIndex;
- (CGFloat)standardGrid:(SFChartStandardGrid*)gird widthForGridColumn:(NSInteger)nCol;
- (CGFloat)standardGrid:(SFChartStandardGrid*)gird heightForGridRow:(NSInteger)nRow;

@end

@protocol SFChartStandardGridDelegate <NSObject>
@optional
- (void)standardGrid:(SFChartStandardGrid*)grid getGridSize:(CGSize)size;

@end

@interface SFChartStandardGrid : SFChartGrid

@property(nonatomic, readwrite)NSInteger nColumn;
@property(nonatomic, readwrite)NSInteger nRow;

@property(nonatomic, weak)id<SFChartStandardGridDataSource> dataSource;
@property(nonatomic, weak)id<SFChartStandardGridDelegate> delegate;


+ (instancetype)standardGridWithColumn:(NSInteger)nCol row:(NSInteger)nRow;
- (void)reloadData;

@end
