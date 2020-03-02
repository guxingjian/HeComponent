//
//  SFChartRange.c
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#include "SFChartRange.h"

SFChartRange SFChartRangeMake(CGFloat startV, CGFloat endV)
{
    SFChartRange range;
    range.startValue = startV;
    range.endValue = endV;
    return range;
}
