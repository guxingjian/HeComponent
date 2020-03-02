//
//  Heqz_ChartCommonGrid.h
//  SinaFinance
//
//  Created by qingzhao on 2018/10/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//
//  定制表格，固定为nRow行nColumn列的标准表格
//  表格中的元素需要dataSource提供
//
#import "Heqz_ChartGrid.h"

@class Heqz_ChartStandardGrid;

@protocol Heqz_ChartStandardGridDataSource <NSObject>

- (NSArray<Heqz_ChartElement*>*)standardGrid:(Heqz_ChartStandardGrid*)gird elementsForGridIndex:(Heqz_ChartGridCellIndex*)cellIndex;
- (CGFloat)standardGrid:(Heqz_ChartStandardGrid*)gird widthForGridColumn:(NSInteger)nCol;
- (CGFloat)standardGrid:(Heqz_ChartStandardGrid*)gird heightForGridRow:(NSInteger)nRow;

@end

@protocol Heqz_ChartStandardGridDelegate <NSObject>
@optional
- (void)standardGrid:(Heqz_ChartStandardGrid*)grid getGridSize:(CGSize)size;

@end

@interface Heqz_ChartStandardGrid : Heqz_ChartGrid

@property(nonatomic, readwrite)NSInteger nColumn;
@property(nonatomic, readwrite)NSInteger nRow;

@property(nonatomic, weak)id<Heqz_ChartStandardGridDataSource> dataSource;
@property(nonatomic, weak)id<Heqz_ChartStandardGridDelegate> delegate;


+ (instancetype)standardGridWithColumn:(NSInteger)nCol row:(NSInteger)nRow;
- (void)reloadData;

@end
