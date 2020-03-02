//
//  Heqz_ChartBaseLayer.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Heqz_ChartElement.h"

// 当Heqz_ChartView创建时指定使用CGContext绘制元素，Heqz_ChartView的layer
// 上会添加Heqz_ChartLayer

@interface Heqz_ChartLayer : CALayer

// Heqz_ChartView中的charts
@property(nonatomic, strong)NSArray* arrayChart;

@end
