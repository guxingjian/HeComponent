//
//  SFChartCommonFunc.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/4.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFChartRange.h"

@interface SFChartCommonFunc : NSObject

// 将文字转化为UIBezierPath，用于CAShapeLayer绘制text
+ (UIBezierPath*)bezierPathWithText:(NSString*)text attributes:(NSDictionary*)textAttr;
+ (UIBezierPath*)bezierPathWithText:(NSString*)text attributes:(NSDictionary*)textAttr contraintWidth:(CGFloat)maxWidth;

// 获取展示文字的CAShapeLayer
+ (CAShapeLayer*)boundingLayerWithText:(NSString*)text attributes:(NSDictionary*)textAttr;
+ (CAShapeLayer*)boundingLayerWithText:(NSAttributedString*)text;

// 多行
+ (CAShapeLayer*)boundingLayerWithText:(NSString*)text attributes:(NSDictionary*)textAttr contraintWidth:(CGFloat)maxWidth;

// 单行缩小，截断
+ (CAShapeLayer*)boundingLayerWithText:(NSString*)text attributes:(NSDictionary*)textAttr maxWidth:(CGFloat)maxWidth scaled:(CGFloat)fScaled;

// 获取fv的绝对值
+ (CGFloat)sf_chartAbs:(CGFloat)fv;

// 获取一组数据的数值范围
+ (SFChartRange)dataRangeWithData:(NSArray*)arrayData;
+ (SFChartRange)dataRangeWithData:(NSArray*)arrayData dataKey:(NSString*)dataKey;

extern NSString* const TextLayerMaxWidthKey;

@end

