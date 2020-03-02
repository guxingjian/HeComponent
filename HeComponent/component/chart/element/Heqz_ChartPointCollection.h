//
//  Heqz_ChartPointCollection.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartElement.h"

// 点集类，CGPoint的集合，用于绘制点集或给折线和填充element设置点集

@interface Heqz_ChartPointCollection : Heqz_ChartElement

// 点元素的半径 单位为点
@property(nonatomic, assign)CGFloat ptRadius;
// 点元素填充颜色
@property(nonatomic, strong)UIColor* ptFillColor;

// 点集的长度
@property(nonatomic, assign)NSUInteger length;

- (instancetype)initWithCapacity:(NSInteger)nCap;

- (void)addPoint:(CGPoint)pt;
- (CGPoint)pointAtIndex:(NSUInteger)nIndex;
- (CGPoint)firstPoint;
- (CGPoint)lastPoint;

- (void)clear;

@end
