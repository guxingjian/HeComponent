//
//  Heqz_ChartCoordinateVerticalAxis.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/1.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartCoordinateAxis.h"

@interface Heqz_ChartCoordinateVerticalAxis : Heqz_ChartCoordinateAxis

// 文字在轴线的左边还是右边
@property(nonatomic, assign)BOOL axisTextOnAxisLineRight;

// 刻度在轴线的左边还是右边
@property(nonatomic, assign)BOOL axisMarkOnAxisLineLeft;

@end
