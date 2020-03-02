//
//  SFChartTextAnimatable.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/8.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartElement.h"

@interface SFChartTextModel : NSObject

@property(nonatomic, strong)NSString* text;
@property(nonatomic, strong)NSDictionary* dicAttr;

// 单位为原始数据
@property(nonatomic, assign)CGPoint posiInValue;

// 单位为点
@property(nonatomic, assign)CGFloat fMinHeight; // y坐标最小值
@property(nonatomic, assign)CGPoint offsetInPoint;
@property(nonatomic, assign)CGPoint anchorPoint;
@property(nonatomic, assign)CGFloat constraintWidth;

+ (instancetype)model;

@end

@interface SFChartTextAnimatable : SFChartElement

@property(nonatomic, strong)NSArray<SFChartTextModel*>* arrayText;

// 设置后，不会使用arrayText中的数据重新创建CAShapeLayer显示，而是使用
// arrayTextLayer中的layer直接显示
@property(nonatomic, strong)NSArray<CAShapeLayer*>* arrayTextLayer;

@end
