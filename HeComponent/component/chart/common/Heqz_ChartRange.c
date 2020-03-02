//
//  Heqz_ChartRange.c
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#include "Heqz_ChartRange.h"

Heqz_ChartRange Heqz_ChartRangeMake(CGFloat startV, CGFloat endV)
{
    Heqz_ChartRange range;
    range.startValue = startV;
    range.endValue = endV;
    return range;
}
