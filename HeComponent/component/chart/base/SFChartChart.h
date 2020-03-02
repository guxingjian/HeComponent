//
//  SFChart.h
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartElement.h"
#import "SFChartRange.h"

// 图表对象，管理图表中的element
@interface SFChartChart : SFChartElement

// 图表的横向数据范围，用于element计算横向坐标
@property(nonatomic, assign)SFChartRange rangeH;
// 图表的纵向数据范围，用于element计算纵向坐标
@property(nonatomic, assign)SFChartRange rangeV;
        
+ (instancetype)chartWithRangeH:(SFChartRange)rangeH rangeV:(SFChartRange)rangeV;

- (void)addElement:(id<SFChartElementProtocol>)element;
- (void)addElements:(NSArray<id<SFChartElementProtocol>> *)arrayElements;
- (void)removeElement:(id<SFChartElementProtocol>)element;
- (void)clearElements;
- (void)updateElements;
- (void)updateElementData:(id<SFChartElementProtocol>)element;
- (void)setNeedShowElement:(id<SFChartElementProtocol>)element;

- (void)setRangeHWithString:(NSString*)strRange;
- (void)setRangeVWithString:(NSString*)strRange;

@end
