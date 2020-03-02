//
//  SFChartCoordinateAxis.h
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartElement.h"
#import "SFChartRange.h"
#import "SFChartAxisMarkLabel.h"

// 坐标刻度配置model
@interface SFChartAxisMarkConfig : NSObject

// 需要显示刻度的数据范围, 单位为原始数据
@property(nonatomic, assign)SFChartRange markRange;
// 刻度的显示间隔 单位为原始数据
@property(nonatomic, assign)CGFloat markDistance;

// 刻度的长度 单位为点
@property(nonatomic, assign)CGFloat markLength;

// 刻度的线宽，单位为点
@property(nonatomic, assign)CGFloat lineWidth;

// 刻度的颜色
@property(nonatomic, strong)UIColor* markColor;

+ (instancetype)markConfig;

@end


// 横向和纵向坐标轴的基类，定义了公共数据和公共方法
@interface SFChartCoordinateAxis : SFChartElement

// 坐标轴的数据范围，单位为原始数据
@property(nonatomic, assign)SFChartRange dataAxisRange;

//  定义轴线element在所属chart中的偏移
@property(nonatomic, assign)CGFloat baseLineOffset;

// 轴线线宽 单位为点
@property(nonatomic, assign)CGFloat lineWidth;
// 轴线颜色 
@property(nonatomic, strong)UIColor* axisColor;

// 长短刻度配置，如需更多刻度类型，请自行扩展
@property(nonatomic, strong)SFChartAxisMarkConfig* shortMarkConfig;
@property(nonatomic, strong)SFChartAxisMarkConfig* longMarkConfig;

// 坐标轴上显示的文字，文字的配置由 SFChartAxisMarkLabel指定
@property(nonatomic, strong)NSArray<SFChartAxisMarkLabel*> * arrayMarkLabel;

+ (instancetype)axisWithDataRange:(SFChartRange)range;

- (SFChartRange)interSectionWithRange:(SFChartRange)range otherRange:(SFChartRange)oRange;


- (void)drawAxisText;
- (void)drawAxisTextWithContext:(CGContextRef)context;

- (void)drawAxisMarkWithConfig:(SFChartAxisMarkConfig*)config;
- (void)drawAxisMarkWithConfig:(SFChartAxisMarkConfig*)config context:(CGContextRef)context;

- (void)drawAxisLine;
- (void)drawAxisLineWithContext:(CGContextRef)context;

- (CGFloat)locationForAxisValue:(CGFloat)value;

@end
