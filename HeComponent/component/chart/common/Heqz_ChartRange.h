//
//  Heqz_ChartRange.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#ifndef Heqz_ChartRange_h
#define Heqz_ChartRange_h

#import <CoreGraphics/CoreGraphics.h>

// 表示数值范围
typedef struct Heqz_ChartRange{
    CGFloat startValue;
    CGFloat endValue;
}Heqz_ChartRange;

Heqz_ChartRange Heqz_ChartRangeMake(CGFloat startV, CGFloat endV);

#endif /* Heqz_ChartRange_h */
