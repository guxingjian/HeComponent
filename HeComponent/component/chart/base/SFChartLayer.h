//
//  SFChartBaseLayer.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SFChartElement.h"

// 当SFChartView创建时指定使用CGContext绘制元素，SFChartView的layer
// 上会添加SFChartLayer

@interface SFChartLayer : CALayer

// SFChartView中的charts
@property(nonatomic, strong)NSArray* arrayChart;

@end
