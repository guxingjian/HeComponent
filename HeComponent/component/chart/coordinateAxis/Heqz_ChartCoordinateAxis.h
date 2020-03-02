//
//  Heqz_ChartCoordinateAxis.h
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartElement.h"
#import "Heqz_ChartRange.h"
#import "Heqz_ChartAxisMarkLabel.h"

// 坐标刻度配置model
@interface Heqz_ChartAxisMarkConfig : NSObject

// 需要显示刻度的数据范围, 单位为原始数据
@property(nonatomic, assign)Heqz_ChartRange markRange;
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
@interface Heqz_ChartCoordinateAxis : Heqz_ChartElement

// 坐标轴的数据范围，单位为原始数据
@property(nonatomic, assign)Heqz_ChartRange dataAxisRange;

//  定义轴线element在所属chart中的偏移
@property(nonatomic, assign)CGFloat baseLineOffset;

// 轴线线宽 单位为点
@property(nonatomic, assign)CGFloat lineWidth;
// 轴线颜色 
@property(nonatomic, strong)UIColor* axisColor;

// 长短刻度配置，如需更多刻度类型，请自行扩展
@property(nonatomic, strong)Heqz_ChartAxisMarkConfig* shortMarkConfig;
@property(nonatomic, strong)Heqz_ChartAxisMarkConfig* longMarkConfig;

// 坐标轴上显示的文字，文字的配置由 Heqz_ChartAxisMarkLabel指定
@property(nonatomic, strong)NSArray<Heqz_ChartAxisMarkLabel*> * arrayMarkLabel;

+ (instancetype)axisWithDataRange:(Heqz_ChartRange)range;

- (Heqz_ChartRange)interSectionWithRange:(Heqz_ChartRange)range otherRange:(Heqz_ChartRange)oRange;


- (void)drawAxisText;
- (void)drawAxisTextWithContext:(CGContextRef)context;

- (void)drawAxisMarkWithConfig:(Heqz_ChartAxisMarkConfig*)config;
- (void)drawAxisMarkWithConfig:(Heqz_ChartAxisMarkConfig*)config context:(CGContextRef)context;

- (void)drawAxisLine;
- (void)drawAxisLineWithContext:(CGContextRef)context;

- (CGFloat)locationForAxisValue:(CGFloat)value;

@end
