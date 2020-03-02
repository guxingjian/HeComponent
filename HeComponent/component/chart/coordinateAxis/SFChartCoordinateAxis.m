//
//  SFChartCoordinateAxis.m
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartCoordinateAxis.h"

@implementation SFChartAxisMarkConfig

+ (instancetype)markConfig
{
    return [[self alloc] init];
}

@end

@implementation SFChartCoordinateAxis

+ (instancetype)axisWithDataRange:(SFChartRange)range
{
    SFChartCoordinateAxis* axis = [[self alloc] init];
    axis.dataAxisRange = range;
    return axis;
}

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    CGContextSaveGState(context);
    
    [self drawAxisMarkWithConfig:self.shortMarkConfig context:context];
    [self drawAxisMarkWithConfig:self.longMarkConfig context:context];
    [self drawAxisLineWithContext:context];
    [self drawAxisTextWithContext:context];
    
    CGContextRestoreGState(context);
    return YES;
}

- (void)setNeedShowChart{
    [self drawAxisMarkWithConfig:self.shortMarkConfig];
    [self drawAxisMarkWithConfig:self.longMarkConfig];
    [self drawAxisLine];
    [self drawAxisText];
}

- (SFChartRange)interSectionWithRange:(SFChartRange)range otherRange:(SFChartRange)oRange
{
    SFChartRange rangeRet;
    rangeRet.startValue = range.startValue;
    if(range.startValue < oRange.startValue)
        rangeRet.startValue = oRange.startValue;
    
    rangeRet.endValue = range.endValue;
    if(range.endValue > oRange.endValue)
        rangeRet.endValue = oRange.endValue;
    
    if(rangeRet.endValue < rangeRet.startValue)
    {
        rangeRet.endValue = 0;
    }
    return rangeRet;
}

- (void)drawAxisTextWithContext:(CGContextRef)context
{
}

- (void)drawAxisMarkWithConfig:(SFChartAxisMarkConfig*)config context:(CGContextRef)context
{
}

- (void)drawAxisLineWithContext:(CGContextRef)context
{
}

- (void)drawAxisText
{
}

- (void)drawAxisMarkWithConfig:(SFChartAxisMarkConfig*)config
{
}

- (void)drawAxisLine
{
}

- (CGFloat)locationForAxisValue:(CGFloat)value
{
    return 0;
}

@end
