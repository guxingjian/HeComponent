//
//  Heqz_Chart.h
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartElement.h"
#import "Heqz_ChartRange.h"

// 图表对象，管理图表中的element
@interface Heqz_ChartChart : Heqz_ChartElement

// 图表的横向数据范围，用于element计算横向坐标
@property(nonatomic, assign)Heqz_ChartRange rangeH;
// 图表的纵向数据范围，用于element计算纵向坐标
@property(nonatomic, assign)Heqz_ChartRange rangeV;
        
+ (instancetype)chartWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV;

- (void)addElement:(id<Heqz_ChartElementProtocol>)element;
- (void)addElements:(NSArray<id<Heqz_ChartElementProtocol>> *)arrayElements;
- (void)removeElement:(id<Heqz_ChartElementProtocol>)element;
- (void)clearElements;
- (void)updateElements;
- (void)updateElementData:(id<Heqz_ChartElementProtocol>)element;
- (void)setNeedShowElement:(id<Heqz_ChartElementProtocol>)element;

- (void)setRangeHWithString:(NSString*)strRange;
- (void)setRangeVWithString:(NSString*)strRange;

@end
