//
//  SFChartRange.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#ifndef SFChartRange_h
#define SFChartRange_h

#import <CoreGraphics/CoreGraphics.h>

// 表示数值范围
typedef struct SFChartRange{
    CGFloat startValue;
    CGFloat endValue;
}SFChartRange;

SFChartRange SFChartRangeMake(CGFloat startV, CGFloat endV);

#endif /* SFChartRange_h */
