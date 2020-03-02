//
//  SFChartCoordinateHorizontalAxis.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/1.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartCoordinateAxis.h"

@interface SFChartCoordinateHorizontalAxis : SFChartCoordinateAxis

@property(nonatomic, assign)CGFloat fNormalW;

// 文字在轴线的上边还是下边
@property(nonatomic, assign)BOOL axisTextAboveAxisLine;

// 刻度在轴线的上边还是下边
@property(nonatomic, assign)BOOL axisMarkBelowAxisLine;

@end
