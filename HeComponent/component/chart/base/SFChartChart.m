//
//  SFChart.m
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartChart.h"

@interface SFChartChart()

@property(nonatomic, strong)NSMutableArray<id<SFChartElementProtocol>> * chartElements;

@end

@implementation SFChartChart

+ (instancetype)chartWithRangeH:(SFChartRange)rangeH rangeV:(SFChartRange)rangeV
{
    SFChartChart* chart = [[self alloc] init];
    chart.rangeH = rangeH;
    chart.rangeV = rangeV;
    return chart;
}

- (NSMutableArray<id<SFChartElementProtocol>> *)chartElements
{
    if(!_chartElements)
    {
        _chartElements = [NSMutableArray array];
    }
    return _chartElements;
}

- (void)addElement:(id<SFChartElementProtocol>)element
{
    if(!element)
        return ;
    if([element respondsToSelector:@selector(setCanvasLayer:)])
    {
        element.canvasLayer = self.canvasLayer;
    }
    if(CGRectEqualToRect(CGRectZero, element.boundingRect))
    {
        element.boundingRect = self.boundingRect;
    }
    [self updateElementData:element];
    [self.chartElements addObject:element];
}

- (void)setCanvasLayer:(CALayer *)canvasLayer
{
    [super setCanvasLayer:canvasLayer];
    
    for(id<SFChartElementProtocol> element in self.chartElements)
    {
        if(!element.canvasLayer)
        {
            element.canvasLayer = canvasLayer;
        }
    }
}

- (void)setBoundingRect:(CGRect)boundingRect
{
    [super setBoundingRect:boundingRect];
    for(id<SFChartElementProtocol> element in self.chartElements)
    {
        element.boundingRect = boundingRect;
    }
}

- (void)addElements:(NSArray<id<SFChartElementProtocol>> *)arrayElements
{
    for(id<SFChartElementProtocol> element in arrayElements)
    {
        [self addElement:element];
    }
}

- (void)updateElementData:(id<SFChartElementProtocol>)element
{
    if(self.rangeH.startValue == 0 && self.rangeH.endValue == 0)
        return ;
    
    if(self.rangeV.startValue == 0 && self.rangeV.endValue == 0)
        return ;
    
    if([element respondsToSelector:@selector(preProcessWithRangeH:rangeV:)])
    {
        [element preProcessWithRangeH:self.rangeH rangeV:self.rangeV];
    }
}

- (void)updateElements
{
    for(id<SFChartElementProtocol> element in self.chartElements)
    {
        [self updateElementData:element];
    }
}

- (void)removeElement:(id<SFChartElementProtocol>)element
{
    [self.chartElements removeObject:element];
}

- (void)clearElements
{
    [self.chartElements removeAllObjects];
}

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    for(SFChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(drawWithContextIfNeed:)])
        {
            [ele drawWithContextIfNeed:context];
        }
    }
    
    return YES;
}

- (void)setNeedShowChart
{
    for(SFChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(setNeedShowChart)])
        {
            [ele clearCanvas];
            [ele setNeedShowChart];
            if(!ele.bDisableAnimation){
                [ele displayShowAnimation];
            }
        }
    }
}

- (void)touchesBeganWithPoint:(CGPoint)point
{
    for(SFChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesBeganWithPoint:)])
        {
            [ele touchesBeganWithPoint:point];
        }
    }
    
    self.userFocusCoordinate = CGPointMake([self pointValue:point.x withHorizontalRange:self.rangeH], [self pointValue:point.y withVerticalRange:self.rangeV]);
}

- (void)touchesMovedWithPoint:(CGPoint)point
{
    for(SFChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesMovedWithPoint:)])
        {
            [ele touchesMovedWithPoint:point];
        }
    }
    
    self.userFocusCoordinate = CGPointMake([self pointValue:point.x withHorizontalRange:self.rangeH], [self pointValue:point.y withVerticalRange:self.rangeV]);
}

- (void)touchesEndedWithPoint:(CGPoint)point
{
    for(SFChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesEndedWithPoint:)])
        {
            [ele touchesEndedWithPoint:point];
        }
    }
    self.userFocusCoordinate = CGPointZero;
}

- (void)touchesCancelledWithPoint:(CGPoint)point
{
    for(SFChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesCancelledWithPoint:)])
        {
            [ele touchesCancelledWithPoint:point];
        }
    }
    self.userFocusCoordinate = CGPointZero;
}

- (CGPoint)convertRealPointToPixcel:(CGPoint)pt
{
    pt.x = [self locationValue:pt.x withHorizontalRange:self.rangeH];
    pt.y = [self locationValue:pt.y withVerticalRange:self.rangeV];
    return pt;
}

- (void)setNeedShowElement:(id<SFChartElementProtocol>)element{
    [element setNeedShowChart];
}

- (void)setRangeHWithString:(NSString*)strRange{
    CGPoint pt = CGPointFromString(strRange);
    self.rangeH = SFChartRangeMake(pt.x, pt.y);
}

- (void)setRangeVWithString:(NSString*)strRange{
    CGPoint pt = CGPointFromString(strRange);
    self.rangeV = SFChartRangeMake(pt.x, pt.y);
}

@end
